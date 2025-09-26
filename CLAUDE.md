# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Development Commands

### Backend (FastAPI + SQLAlchemy + PostgreSQL)
```bash
cd backend

# Setup virtual environment
python -m venv venv

# Windows activation
venv\Scripts\activate
# or use: activate.bat

# Linux/Mac activation
source venv/bin/activate
# or use: source activate.sh

# Install dependencies
pip install -r requirements.txt

# Configure database connection
cp .env.example .env
# Edit .env file with your PostgreSQL credentials

# Run development server
uvicorn main:app --reload
```

Backend runs on http://localhost:8000

### Frontend (Next.js + TypeScript)
```bash
cd frontend

# Install dependencies
npm install

# Development server
npm run dev

# Production build
npm run build

# Start production server
npm start

# Lint code
npm run lint
```

Frontend runs on http://localhost:3000

## Architecture Overview

**Tech Stack:**
- Backend: FastAPI with SQLAlchemy ORM and PostgreSQL database
- Frontend: Next.js 14 with TypeScript, React 18, and Tailwind CSS
- Database: PostgreSQL with automatic initialization

**Project Structure:**
- `backend/` - FastAPI application with database models and API endpoints
- `backend/.env.example` - Environment configuration template
- `frontend/` - Next.js application with React components
- `prueba_tecnica_estructura_db.sql` - Database schema reference
- `Desafío Técnico.pdf` - Project requirements documentation

## Key Components

### Backend (`backend/`)
- `main.py` - FastAPI app with CORS middleware and API endpoints
- `models.py` - SQLAlchemy models and Pydantic schemas
- `database.py` - Database connection and session management
- `init_db.py` - Database initialization with sample data
- `requirements.txt` - Python dependencies (includes psycopg2-binary for PostgreSQL)

### Frontend (`frontend/`)
- `app/` - Next.js App Router structure
- `components/Dashboard.tsx` - Main dashboard component (9k+ lines)
- `package.json` - Node.js dependencies with Next.js, React, TypeScript, and Tailwind

### Database Schema
The PostgreSQL database includes:
- CRM tables (users, campaigns, contacts, gestiones)
- Metrics calculation tables (gestiones_resultado)
- Dashboard snapshots table for saving filtered states

### Database Setup Requirements
**PostgreSQL Installation:**
1. Install PostgreSQL server locally or use a hosted service
2. Create a database named `crm_dashboard`
3. Configure database connection in `.env` file

**Environment Configuration:**
```bash
# Copy the example environment file
cp backend/.env.example backend/.env

# Edit with your PostgreSQL credentials:
DATABASE_URL=postgresql://your_username:your_password@localhost:5432/crm_dashboard
```

## API Endpoints

- `GET /metrics` - Calculate CRM metrics with optional filters (date range, campaign, broker)
- `POST /snapshots` - Create snapshot with current metrics and filters
- `GET /snapshots` - List all saved snapshots
- `GET /snapshots/{id}` - Get specific snapshot
- `GET /campaigns` - List available campaigns
- `GET /users` - List available users/brokers

## Development Workflow

1. **Database**: PostgreSQL database is automatically initialized when backend starts (tables and sample data)
2. **Environment**: Requires `.env` file with PostgreSQL connection details
3. **Dependencies**: Backend includes `psycopg2-binary` for PostgreSQL connectivity
4. **CORS**: Configured for local development (localhost:3000)
5. **Hot Reload**: Both backend (`--reload`) and frontend (`npm run dev`) support hot reload
6. **TypeScript**: Frontend uses TypeScript with strict mode disabled in tsconfig.json

## Key Business Logic

**Metrics Calculations:**
1. **Contactabilidad** = (gestiones with resultado_id IN (1,2,8) ÷ total gestiones) × 100
2. **Penetración Bruta** = (gestiones with resultado_id = 1 ÷ total gestiones) × 100
3. **Penetración Neta** = (gestiones with resultado_id = 1 ÷ gestiones with contacto) × 100

**Filters:**
- Date range (fecha_inicio, fecha_fin) on gestiones.timestamp
- Campaign (id_campaign)
- Broker/Agent (id_broker)

## Testing & Quality

The project uses:
- ESLint for frontend code linting (`npm run lint`)
- TypeScript for type checking
- Automatic database seeding with sample data for testing

Always run `npm run lint` in the frontend directory before committing changes to ensure code quality.