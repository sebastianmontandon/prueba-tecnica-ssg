from fastapi import FastAPI, Depends, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from sqlalchemy.orm import Session
from sqlalchemy import text
from database import get_db, engine
from models import (
    Base, MetricsResponse, FiltersRequest, SnapshotCreate,
    SnapshotResponse, DashboardSnapshot, Campaign, User,
    CampaignResponse, UserResponse
)
import json
from typing import List

app = FastAPI(title="CRM Dashboard API", version="1.0.0")

app.add_middleware(
    CORSMiddleware,
    allow_origins=["http://localhost:3000"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Initialize database
from init_db import init_database
init_database()

@app.get("/")
def read_root():
    return {"message": "CRM Dashboard API"}

@app.get("/metrics", response_model=MetricsResponse)
def get_metrics(
    fecha_inicio: str = None,
    fecha_fin: str = None,
    id_campaign: int = None,
    id_broker: int = None,
    db: Session = Depends(get_db)
):
    # Base query for gestiones
    base_query = """
    SELECT
        COUNT(*) as total_gestiones,
        COUNT(CASE WHEN gr.id IN (1, 2, 8) THEN 1 END) as gestiones_con_contacto,
        COUNT(CASE WHEN gr.id = 1 THEN 1 END) as ventas
    FROM gestiones g
    LEFT JOIN gestiones_resultado gr ON g.id_resultado = gr.id
    WHERE 1=1
    """

    params = {}

    # Add filters
    if fecha_inicio:
        base_query += " AND g.timestamp >= :fecha_inicio"
        params['fecha_inicio'] = fecha_inicio.replace('-', '') + '000000'

    if fecha_fin:
        base_query += " AND g.timestamp <= :fecha_fin"
        params['fecha_fin'] = fecha_fin.replace('-', '') + '235959'

    if id_campaign:
        base_query += " AND g.id_campaign = :id_campaign"
        params['id_campaign'] = id_campaign

    if id_broker:
        base_query += " AND g.id_broker = :id_broker"
        params['id_broker'] = id_broker

    result = db.execute(text(base_query), params).fetchone()

    total_gestiones = result.total_gestiones or 0
    gestiones_con_contacto = result.gestiones_con_contacto or 0
    ventas = result.ventas or 0

    # Calculate metrics
    contactabilidad = (gestiones_con_contacto / total_gestiones * 100) if total_gestiones > 0 else 0
    penetracion_bruta = (ventas / total_gestiones * 100) if total_gestiones > 0 else 0
    penetracion_neta = (ventas / gestiones_con_contacto * 100) if gestiones_con_contacto > 0 else 0

    return MetricsResponse(
        contactabilidad=round(contactabilidad, 2),
        penetracion_bruta=round(penetracion_bruta, 2),
        penetracion_neta=round(penetracion_neta, 2),
        total_gestiones=total_gestiones,
        gestiones_con_contacto=gestiones_con_contacto,
        ventas=ventas
    )

@app.post("/snapshots", response_model=SnapshotResponse)
def create_snapshot(snapshot: SnapshotCreate, db: Session = Depends(get_db)):
    db_snapshot = DashboardSnapshot(
        name=snapshot.name,
        filters=json.dumps(snapshot.filters),
        metrics=json.dumps(snapshot.metrics)
    )
    db.add(db_snapshot)
    db.commit()
    db.refresh(db_snapshot)

    return SnapshotResponse(
        id=db_snapshot.id,
        name=db_snapshot.name,
        filters=json.loads(db_snapshot.filters),
        metrics=json.loads(db_snapshot.metrics),
        created_at=db_snapshot.created_at
    )

@app.get("/snapshots", response_model=List[SnapshotResponse])
def get_snapshots(db: Session = Depends(get_db)):
    snapshots = db.query(DashboardSnapshot).order_by(DashboardSnapshot.created_at.desc()).all()
    return [
        SnapshotResponse(
            id=snapshot.id,
            name=snapshot.name,
            filters=json.loads(snapshot.filters),
            metrics=json.loads(snapshot.metrics),
            created_at=snapshot.created_at
        )
        for snapshot in snapshots
    ]

@app.get("/snapshots/{snapshot_id}", response_model=SnapshotResponse)
def get_snapshot(snapshot_id: int, db: Session = Depends(get_db)):
    snapshot = db.query(DashboardSnapshot).filter(DashboardSnapshot.id == snapshot_id).first()
    if not snapshot:
        raise HTTPException(status_code=404, detail="Snapshot not found")

    return SnapshotResponse(
        id=snapshot.id,
        name=snapshot.name,
        filters=json.loads(snapshot.filters),
        metrics=json.loads(snapshot.metrics),
        created_at=snapshot.created_at
    )

@app.get("/campaigns", response_model=List[CampaignResponse])
def get_campaigns(db: Session = Depends(get_db)):
    campaigns = db.query(Campaign).all()
    return [
        CampaignResponse(id=c.id, codigo=c.codigo, nombre=c.nombre)
        for c in campaigns
    ]

@app.get("/users", response_model=List[UserResponse])
def get_users(db: Session = Depends(get_db)):
    users = db.query(User).all()
    return [
        UserResponse(id=u.id, nombre=u.nombre, apellido=u.apellido)
        for u in users
    ]