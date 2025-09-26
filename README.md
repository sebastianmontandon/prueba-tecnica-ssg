# CRM Dashboard - Prueba Técnica

Dashboard para visualización de métricas de CRM con capacidad de filtrado y snapshots.

## Arquitectura

- **Backend**: FastAPI + SQLAlchemy + SQLite/PostgreSQL
- **Frontend**: Next.js 14 + TypeScript + Tailwind CSS
- **Base de datos**: SQLite (desarrollo, para poder visualizar los datos de la bd utilice esta app https://sqlitebrowser.org/dl/) / PostgreSQL (producción)

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
- PostgreSQL (opcional, para producción)

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

# Inicializar base de datos (primera vez)
python init_db.py
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

# Ejecutar servidor
uvicorn main:app --reload

```
El backend estará en http://localhost:8000

### 4. Ejecutar Frontend (en otra terminal)
```bash
cd frontend
npm run dev
```
El frontend estará en http://localhost:3000 (o 3001/3002 si el puerto está ocupado)

### 5. Configuración de Base de Datos (Opcional)

Para usar PostgreSQL en lugar de SQLite:

```bash
# Copiar archivo de configuración
cp backend/.env.example backend/.env

# Editar backend/.env con tus credenciales de PostgreSQL
DATABASE_URL=postgresql://usuario:contraseña@localhost:5432/crm_dashboard
```

### 6. Acceder al dashboard
- Dashboard: http://localhost:3000 (o puerto disponible)
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
4. **Historial**: Visualización de snapshots guardados en grid responsivo

## Base de Datos

### SQLite (Desarrollo)
La base de datos SQLite se inicializa automáticamente con:
- Estructura de tablas del CRM
- Tabla dashboard_snapshots para almacenar snapshots
- Datos de ejemplo para testing
- Archivo: `backend/crm_dashboard.db`

### PostgreSQL (Producción)
Compatible con PostgreSQL mediante configuración en archivo `.env`:
- Configuración flexible de host, puerto y credenciales
ACLARACIÓN: Por falta de tiempo no fue posible resolver un issue que se presento con la codificacion UTF de los datos, por eso se opto por implementarlo de forma temporal en SQLite.

## Consideraciones de Desarrollo

- **Base de datos dual**: SQLite para desarrollo, PostgreSQL para producción
- **Timestamps**: Formato YYYYMMDDhhiiss (char) para compatibilidad
- **Robustez**: Manejo de división por cero en Penetración Neta
- **CORS**: Habilitado para desarrollo local
- **Filtros**: Opcionales y combinables con validación
- **Inicialización**: Automática de datos y esquema
- **UI/UX**: Interfaz responsiva con diseño moderno

## Archivos de Configuración

- `backend/.env.example`: Plantilla de configuración de base de datos
- `backend/init_db.py`: Script de inicialización de base de datos