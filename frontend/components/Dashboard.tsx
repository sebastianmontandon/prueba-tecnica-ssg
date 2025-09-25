'use client'

import { useState, useEffect } from 'react'

interface Metrics {
  contactabilidad: number
  penetracion_bruta: number
  penetracion_neta: number
  total_gestiones: number
  gestiones_con_contacto: number
  ventas: number
}

interface Campaign {
  id: number
  codigo: string
  nombre: string
}

interface User {
  id: number
  nombre: string
  apellido: string
}

interface Snapshot {
  id: number
  name: string
  filters: any
  metrics: Metrics
  created_at: string
}

const API_URL = process.env.NEXT_PUBLIC_API_URL || 'http://localhost:8000'

export default function Dashboard() {
  const [metrics, setMetrics] = useState<Metrics | null>(null)
  const [campaigns, setCampaigns] = useState<Campaign[]>([])
  const [users, setUsers] = useState<User[]>([])
  const [snapshots, setSnapshots] = useState<Snapshot[]>([])
  const [loading, setLoading] = useState(false)

  const [filters, setFilters] = useState({
    fecha_inicio: '',
    fecha_fin: '',
    id_campaign: '',
    id_broker: ''
  })

  const [snapshotName, setSnapshotName] = useState('')

  useEffect(() => {
    fetchCampaigns()
    fetchUsers()
    fetchSnapshots()
    fetchMetrics()
  }, [])

  const fetchMetrics = async () => {
    setLoading(true)
    try {
      const params = new URLSearchParams()
      if (filters.fecha_inicio) params.append('fecha_inicio', filters.fecha_inicio)
      if (filters.fecha_fin) params.append('fecha_fin', filters.fecha_fin)
      if (filters.id_campaign) params.append('id_campaign', filters.id_campaign)
      if (filters.id_broker) params.append('id_broker', filters.id_broker)

      const response = await fetch(`${API_URL}/metrics?${params}`)
      const data = await response.json()
      setMetrics(data)
    } catch (error) {
      console.error('Error fetching metrics:', error)
    }
    setLoading(false)
  }

  const fetchCampaigns = async () => {
    try {
      const response = await fetch(`${API_URL}/campaigns`)
      const data = await response.json()
      setCampaigns(data)
    } catch (error) {
      console.error('Error fetching campaigns:', error)
    }
  }

  const fetchUsers = async () => {
    try {
      const response = await fetch(`${API_URL}/users`)
      const data = await response.json()
      setUsers(data)
    } catch (error) {
      console.error('Error fetching users:', error)
    }
  }

  const fetchSnapshots = async () => {
    try {
      const response = await fetch(`${API_URL}/snapshots`)
      const data = await response.json()
      setSnapshots(data)
    } catch (error) {
      console.error('Error fetching snapshots:', error)
    }
  }

  const saveSnapshot = async () => {
    if (!snapshotName || !metrics) return

    try {
      const response = await fetch(`${API_URL}/snapshots`, {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify({
          name: snapshotName,
          filters,
          metrics
        }),
      })

      if (response.ok) {
        setSnapshotName('')
        fetchSnapshots()
      }
    } catch (error) {
      console.error('Error saving snapshot:', error)
    }
  }

  return (
    <div className="space-y-6">
      {/* Filtros */}
      <div className="bg-white p-6 rounded-lg shadow">
        <h2 className="text-xl font-semibold mb-4">Filtros</h2>
        <div className="grid grid-cols-1 md:grid-cols-4 gap-4">
          <div>
            <label className="block text-sm font-medium mb-2">Fecha Inicio</label>
            <input
              type="date"
              value={filters.fecha_inicio}
              onChange={(e) => setFilters({...filters, fecha_inicio: e.target.value})}
              className="w-full border rounded px-3 py-2"
            />
          </div>
          <div>
            <label className="block text-sm font-medium mb-2">Fecha Fin</label>
            <input
              type="date"
              value={filters.fecha_fin}
              onChange={(e) => setFilters({...filters, fecha_fin: e.target.value})}
              className="w-full border rounded px-3 py-2"
            />
          </div>
          <div>
            <label className="block text-sm font-medium mb-2">Campaña</label>
            <select
              value={filters.id_campaign}
              onChange={(e) => setFilters({...filters, id_campaign: e.target.value})}
              className="w-full border rounded px-3 py-2"
            >
              <option value="">Todas las campañas</option>
              {campaigns.map(campaign => (
                <option key={campaign.id} value={campaign.id}>
                  {campaign.codigo} - {campaign.nombre}
                </option>
              ))}
            </select>
          </div>
          <div>
            <label className="block text-sm font-medium mb-2">Agente</label>
            <select
              value={filters.id_broker}
              onChange={(e) => setFilters({...filters, id_broker: e.target.value})}
              className="w-full border rounded px-3 py-2"
            >
              <option value="">Todos los agentes</option>
              {users.map(user => (
                <option key={user.id} value={user.id}>
                  {user.nombre} {user.apellido}
                </option>
              ))}
            </select>
          </div>
        </div>
        <div className="mt-4">
          <button
            onClick={fetchMetrics}
            disabled={loading}
            className="bg-blue-600 text-white px-4 py-2 rounded hover:bg-blue-700 disabled:opacity-50"
          >
            {loading ? 'Cargando...' : 'Aplicar Filtros'}
          </button>
        </div>
      </div>

      {/* KPIs */}
      {metrics && (
        <div className="grid grid-cols-1 md:grid-cols-3 gap-6">
          <div className="bg-white p-6 rounded-lg shadow">
            <h3 className="text-lg font-semibold text-gray-700">Contactabilidad</h3>
            <p className="text-3xl font-bold text-blue-600">{metrics.contactabilidad}%</p>
            <p className="text-sm text-gray-500">
              {metrics.gestiones_con_contacto} de {metrics.total_gestiones} gestiones
            </p>
          </div>
          <div className="bg-white p-6 rounded-lg shadow">
            <h3 className="text-lg font-semibold text-gray-700">Penetración Bruta</h3>
            <p className="text-3xl font-bold text-green-600">{metrics.penetracion_bruta}%</p>
            <p className="text-sm text-gray-500">
              {metrics.ventas} ventas de {metrics.total_gestiones} gestiones
            </p>
          </div>
          <div className="bg-white p-6 rounded-lg shadow">
            <h3 className="text-lg font-semibold text-gray-700">Penetración Neta</h3>
            <p className="text-3xl font-bold text-purple-600">{metrics.penetracion_neta}%</p>
            <p className="text-sm text-gray-500">
              {metrics.ventas} ventas de {metrics.gestiones_con_contacto} contactos efectivos
            </p>
          </div>
        </div>
      )}

      {/* Guardar Snapshot */}
      {metrics && (
        <div className="bg-white p-6 rounded-lg shadow">
          <h2 className="text-xl font-semibold mb-4">Guardar Snapshot</h2>
          <div className="flex gap-4">
            <input
              type="text"
              value={snapshotName}
              onChange={(e) => setSnapshotName(e.target.value)}
              placeholder="Nombre del snapshot"
              className="flex-1 border rounded px-3 py-2"
            />
            <button
              onClick={saveSnapshot}
              className="bg-green-600 text-white px-4 py-2 rounded hover:bg-green-700"
            >
              Guardar Snapshot
            </button>
          </div>
        </div>
      )}

      {/* Lista de Snapshots */}
      <div className="bg-white p-6 rounded-lg shadow">
        <h2 className="text-xl font-semibold mb-4">Snapshots Guardados</h2>
        <div className="space-y-4">
          {snapshots.map(snapshot => (
            <div key={snapshot.id} className="border rounded p-4">
              <div className="flex justify-between items-start">
                <div>
                  <h3 className="font-semibold">{snapshot.name}</h3>
                  <p className="text-sm text-gray-500">
                    {new Date(snapshot.created_at).toLocaleString()}
                  </p>
                </div>
                <div className="text-right">
                  <div className="text-sm">
                    <span className="font-medium">Contactabilidad:</span> {snapshot.metrics.contactabilidad}%
                  </div>
                  <div className="text-sm">
                    <span className="font-medium">P. Bruta:</span> {snapshot.metrics.penetracion_bruta}%
                  </div>
                  <div className="text-sm">
                    <span className="font-medium">P. Neta:</span> {snapshot.metrics.penetracion_neta}%
                  </div>
                </div>
              </div>
            </div>
          ))}
        </div>
      </div>
    </div>
  )
}