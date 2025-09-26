from sqlalchemy import Column, Integer, String, Text, BigInteger, DateTime
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import sessionmaker
from pydantic import BaseModel
from datetime import datetime
from typing import Optional, List

Base = declarative_base()

# Tablas de catálogo
class UsersTipos(Base):
    __tablename__ = "users_tipos"
    id = Column(Integer, primary_key=True)
    nombre = Column(String(32))
    descripcion = Column(Text)

class UsersEstados(Base):
    __tablename__ = "users_estados"
    id = Column(Integer, primary_key=True)
    nombre = Column(String(32))

class UsersGrupos(Base):
    __tablename__ = "users_grupos"
    id = Column(Integer, primary_key=True)
    nombre = Column(String(32))
    descripcion = Column(Text)

class UsersCategorias(Base):
    __tablename__ = "users_categorias"
    id = Column(Integer, primary_key=True)
    categoria = Column(String(32))

class ContactosEstado(Base):
    __tablename__ = "contactos_estado"
    id = Column(Integer, primary_key=True)
    nombre = Column(String(32))

class CampaignsEstados(Base):
    __tablename__ = "campaigns_estados"
    id = Column(Integer, primary_key=True)
    nombre = Column(String(32))
    descripcion = Column(Text)

class GestionesTipo(Base):
    __tablename__ = "gestiones_tipo"
    id = Column(Integer, primary_key=True)
    nombre = Column(String(32))

class Telefonos(Base):
    __tablename__ = "telefonos"
    id = Column(BigInteger, primary_key=True)
    tipo = Column(Integer)
    numero = Column(BigInteger)

# SQLAlchemy Models
class User(Base):
    __tablename__ = "users"

    id = Column(Integer, primary_key=True)
    id_tipo = Column(Integer)
    id_estado = Column(Integer)
    id_grupo = Column(Integer)
    id_categoria = Column(Integer)
    ci = Column(Integer)
    nombre = Column(String(32))
    apellido = Column(String(32))
    usuario = Column(String(32))
    password = Column(Text)
    id_tipo_escala = Column(Integer)

class Campaign(Base):
    __tablename__ = "campaigns"

    id = Column(Integer, primary_key=True)
    id_estado = Column(Integer)
    codigo = Column(String(16))
    nombre = Column(String(64))
    descripcion = Column(Text)
    brokers = Column(Text)
    fc_inicio = Column(Integer)
    fc_final = Column(Integer)

class Contacto(Base):
    __tablename__ = "contactos"

    id = Column(Integer, primary_key=True)
    id_estado = Column(Integer)
    id_domicilio = Column(Integer)
    id_ocupacion = Column(Integer)
    id_estado_civil = Column(Integer)
    ci = Column(BigInteger)
    nombre1 = Column(String(32))
    nombre2 = Column(String(32))
    apellido1 = Column(String(32))
    apellido2 = Column(String(32))
    fc_nacimiento = Column(Integer)
    sexo = Column(String(1))
    zurdo = Column(String(1))
    id_tel_fijo1 = Column(Integer)
    id_tel_fijo2 = Column(Integer)
    id_tel_movil1 = Column(Integer)
    id_tel_movil2 = Column(Integer)
    email = Column(Text)
    id_userinsert = Column(Integer)
    id_fuente_dato = Column(Integer)
    se_queda = Column(Integer)
    timestamp = Column(BigInteger)
    mascota = Column(Integer)

class Gestion(Base):
    __tablename__ = "gestiones"

    id = Column(Integer, primary_key=True)
    id_tipo = Column(Integer)
    id_campaign = Column(Integer)
    id_broker = Column(Integer)
    id_contacto = Column(Integer)
    id_resultado = Column(Integer)
    notas = Column(Text)
    timestamp = Column(String(14))
    id_tel_fijo1 = Column(Integer)

class GestionResultado(Base):
    __tablename__ = "gestiones_resultado"

    id = Column(Integer, primary_key=True)
    nombre = Column(String(32))

class DashboardSnapshot(Base):
    __tablename__ = "dashboard_snapshots"

    id = Column(Integer, primary_key=True, autoincrement=True)
    name = Column(String(100))
    filters = Column(Text)  # JSON string
    metrics = Column(Text)  # JSON string
    created_at = Column(DateTime, default=datetime.utcnow)

# Pydantic Models
class MetricsResponse(BaseModel):
    contactabilidad: float
    penetracion_bruta: float
    penetracion_neta: float
    total_gestiones: int
    gestiones_con_contacto: int
    ventas: int

class FiltersRequest(BaseModel):
    fecha_inicio: Optional[str] = None
    fecha_fin: Optional[str] = None
    id_campaign: Optional[int] = None
    id_broker: Optional[int] = None

class SnapshotCreate(BaseModel):
    name: str
    filters: dict
    metrics: dict

class SnapshotResponse(BaseModel):
    id: int
    name: str
    filters: dict
    metrics: dict
    created_at: datetime

    class Config:
        from_attributes = True

class CampaignResponse(BaseModel):
    id: int
    codigo: str
    nombre: str

class UserResponse(BaseModel):
    id: int
    nombre: str
    apellido: str