# CRM Dashboard - Prueba Técnica

Dashboard para visualización de métricas de CRM con capacidad de filtrado y snapshots.

## Arquitectura

- **Backend**: FastAPI + SQLAlchemy + SQLite
- **Frontend**: Next.js + Tailwind CSS
- **Base de datos**: SQLite (archivo local)

## Métricas Implementadas

1. **Contactabilidad** = (gestiones con contacto efectivo ÷ total gestiones) × 100
   - Gestiones con contacto: resultado_id IN (1, 2, 8) - "Coordinado", "Contactado", "Agendado"

2. **Penetración Bruta** = (ventas ÷ total gestiones) × 100
   - Ventas: resultado_id = 1 - "Coordinado"

3. **Penetración Neta** = (ventas ÷ gestiones con contacto efectivo) × 100
   - Evita división por cero cuando no hay contactos efectivos

## Filtros Disponibles

- **Rango de fechas**: Filtro por campo timestamp de gestiones
- **Campaña**: Filtro por id_campaign
- **Agente**: Filtro por id_broker (usuario)

## Instalación y Uso Local

### Prerrequisitos
- Python 3.8+ instalado
- Node.js 18+ instalado

### 1. Configurar Backend
```bash
cd backend

# Crear y activar entorno virtual
python -m venv venv

# Windows
venv\Scripts\activate
# o usar el script: activate.bat

# Linux/Mac
source venv/bin/activate
# o usar el script: source activate.sh

# Instalar dependencias
pip install -r requirements.txt
```

### 2. Configurar Frontend
```bash
cd frontend
npm install
```

### 3. Ejecutar Backend
```bash
cd backend

# Activar entorno virtual (si no está activado)
# Windows: venv\Scripts\activate
# Linux/Mac: source venv/bin/activate

uvicorn main:app --reload
```
El backend estará en http://localhost:8000

### 4. Ejecutar Frontend (en otra terminal)
```bash
cd frontend
npm run dev
```
El frontend estará en http://localhost:3000

### 5. Acceder al dashboard
- Dashboard: http://localhost:3000
- API Documentation: http://localhost:8000/docs

## Endpoints API

- `GET /metrics` - Obtiene métricas con filtros opcionales
- `POST /snapshots` - Crea un snapshot con métricas y filtros
- `GET /snapshots` - Lista todos los snapshots
- `GET /snapshots/{id}` - Obtiene un snapshot específico
- `GET /campaigns` - Lista campañas disponibles
- `GET /users` - Lista usuarios/agentes disponibles

## Funcionalidades del Dashboard

1. **Visualización de KPIs**: Cards con métricas principales
2. **Filtros dinámicos**: Fecha, campaña y agente
3. **Snapshots**: Guardar estado actual de métricas con filtros aplicados
4. **Historial**: Visualización de snapshots guardados

## Base de Datos

La base de datos SQLite se inicializa automáticamente con:
- Estructura de tablas del CRM
- Tabla dashboard_snapshots para almacenar snapshots
- Datos de ejemplo para testing
- Archivo: `backend/crm_dashboard.db`

## Consideraciones de Desarrollo

- Base de datos SQLite para simplicidad y portabilidad
- Timestamps en formato YYYYMMDDhhiiss (char) para compatibilidad
- Manejo de división por cero en Penetración Neta
- CORS habilitado para desarrollo local
- Filtros opcionales y combinables
- Inicialización automática de datos al arrancar el backend