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
    <div className="min-h-screen bg-gray-50 p-6">
      {/* Dashboard Header */}
      <div className="mb-8">
        <h1 className="text-3xl font-bold text-gray-900">
          Dashboard CRM - Métricas de Gestión
        </h1>
        <p className="text-gray-600 mt-2">Monitoreo en tiempo real de indicadores clave de rendimiento</p>

        {metrics && (
          <div className="mt-4 grid grid-cols-1 md:grid-cols-4 gap-4">
            <div className="bg-white rounded-lg p-4 shadow-sm border">
              <div>
                <p className="text-sm text-gray-600">Total Gestiones</p>
                <p className="text-xl font-bold text-gray-900">{metrics.total_gestiones}</p>
              </div>
            </div>
            <div className="bg-white rounded-lg p-4 shadow-sm border">
              <div>
                <p className="text-sm text-gray-600">Contactos Efectivos</p>
                <p className="text-xl font-bold text-gray-900">{metrics.gestiones_con_contacto}</p>
              </div>
            </div>
            <div className="bg-white rounded-lg p-4 shadow-sm border">
              <div>
                <p className="text-sm text-gray-600">Ventas Cerradas</p>
                <p className="text-xl font-bold text-gray-900">{metrics.ventas}</p>
              </div>
            </div>
            <div className="bg-white rounded-lg p-4 shadow-sm border">
              <div>
                <p className="text-sm text-gray-600">Efectividad</p>
                <p className="text-xl font-bold text-gray-900">{((metrics.ventas / metrics.total_gestiones) * 100).toFixed(1)}%</p>
              </div>
            </div>
          </div>
        )}
      </div>

      <div className="space-y-6">
        {/* Enhanced Filters */}
      <div className="bg-white p-6 rounded-xl shadow-lg">
        <div className="mb-6">
          <h2 className="text-xl font-semibold text-gray-800">Filtros Avanzados</h2>
        </div>

        <div className="grid grid-cols-1 md:grid-cols-4 gap-6 mb-6">
          <div className="space-y-2">
            <label className="block text-sm font-medium text-gray-700">Fecha Inicio</label>
            <input
              type="date"
              value={filters.fecha_inicio}
              onChange={(e) => setFilters({...filters, fecha_inicio: e.target.value})}
              className="w-full border border-gray-300 rounded-lg px-3 py-2 focus:ring-2 focus:ring-blue-500 focus:border-blue-500 transition-colors"
            />
          </div>

          <div className="space-y-2">
            <label className="block text-sm font-medium text-gray-700">Fecha Fin</label>
            <input
              type="date"
              value={filters.fecha_fin}
              onChange={(e) => setFilters({...filters, fecha_fin: e.target.value})}
              className="w-full border border-gray-300 rounded-lg px-3 py-2 focus:ring-2 focus:ring-blue-500 focus:border-blue-500 transition-colors"
            />
          </div>

          <div className="space-y-2">
            <label className="block text-sm font-medium text-gray-700">Campaña</label>
            <select
              value={filters.id_campaign}
              onChange={(e) => setFilters({...filters, id_campaign: e.target.value})}
              className="w-full border border-gray-300 rounded-lg px-3 py-2 focus:ring-2 focus:ring-blue-500 focus:border-blue-500 transition-colors"
            >
              <option value="">Todas las campañas</option>
              {campaigns.map(campaign => (
                <option key={campaign.id} value={campaign.id}>
                  {campaign.codigo} - {campaign.nombre}
                </option>
              ))}
            </select>
            <p className="text-xs text-gray-500">{campaigns.length} campañas disponibles</p>
          </div>

          <div className="space-y-2">
            <label className="block text-sm font-medium text-gray-700">Agente</label>
            <select
              value={filters.id_broker}
              onChange={(e) => setFilters({...filters, id_broker: e.target.value})}
              className="w-full border border-gray-300 rounded-lg px-3 py-2 focus:ring-2 focus:ring-blue-500 focus:border-blue-500 transition-colors"
            >
              <option value="">Todos los agentes</option>
              {users.map(user => (
                <option key={user.id} value={user.id}>
                  {user.nombre} {user.apellido}
                </option>
              ))}
            </select>
            <p className="text-xs text-gray-500">{users.length} agentes activos</p>
          </div>
        </div>

        <div className="flex justify-between items-center">
          <div className="flex items-center space-x-4 text-sm text-gray-600">
            <span>Filtros activos: {[filters.fecha_inicio, filters.fecha_fin, filters.id_campaign, filters.id_broker].filter(f => f).length}</span>
          </div>
          <div className="flex space-x-3">
            <button
              onClick={() => setFilters({ fecha_inicio: '', fecha_fin: '', id_campaign: '', id_broker: '' })}
              className="px-4 py-2 border border-gray-300 rounded-lg text-gray-700 hover:bg-gray-50 transition-colors"
            >
              Limpiar
            </button>
            <button
              onClick={fetchMetrics}
              disabled={loading}
              className="bg-gradient-to-r from-blue-600 to-blue-700 text-white px-6 py-2 rounded-lg hover:from-blue-700 hover:to-blue-800 disabled:opacity-50 disabled:cursor-not-allowed transition-all duration-200 shadow-lg"
            >
              {loading ? 'Cargando...' : 'Aplicar Filtros'}
            </button>
          </div>
        </div>
      </div>

      {/* Loading State */}
      {loading && (
        <div className="flex justify-center items-center py-12">
          <div className="animate-spin rounded-full h-12 w-12 border-b-2 border-blue-600"></div>
          <span className="ml-3 text-gray-600">Cargando métricas...</span>
        </div>
      )}

      {/* Enhanced KPIs */}
      {metrics && !loading && (
        <div className="grid grid-cols-1 md:grid-cols-3 gap-6">
          {/* Contactabilidad */}
          <div className="bg-white p-6 rounded-xl shadow-lg hover:shadow-xl transition-shadow border-l-4 border-blue-500">
            <div className="flex items-center justify-between mb-4">
              <h3 className="text-lg font-semibold text-gray-700">Contactabilidad</h3>
              <span className="text-xs bg-blue-100 text-blue-800 px-2 py-1 rounded-full">
                Conectividad
              </span>
            </div>
            <div className="space-y-2">
              <div className="flex items-baseline">
                <p className="text-3xl font-bold text-blue-600">{metrics.contactabilidad.toFixed(1)}%</p>
              </div>
              <div className="w-full bg-gray-200 rounded-full h-2">
                <div
                  className="bg-blue-500 h-2 rounded-full transition-all duration-1000"
                  style={{ width: `${metrics.contactabilidad}%` }}
                ></div>
              </div>
              <p className="text-sm text-gray-600 flex items-center justify-between">
                <span><strong>{metrics.gestiones_con_contacto}</strong> contactos efectivos</span>
                <span className="text-xs text-gray-400">de {metrics.total_gestiones}</span>
              </p>
            </div>
          </div>

          {/* Penetración Bruta */}
          <div className="bg-white p-6 rounded-xl shadow-lg hover:shadow-xl transition-shadow border-l-4 border-green-500">
            <div className="flex items-center justify-between mb-4">
              <h3 className="text-lg font-semibold text-gray-700">Penetración Bruta</h3>
              <span className="text-xs bg-green-100 text-green-800 px-2 py-1 rounded-full">
                Global
              </span>
            </div>
            <div className="space-y-2">
              <div className="flex items-baseline">
                <p className="text-3xl font-bold text-green-600">{metrics.penetracion_bruta.toFixed(1)}%</p>
              </div>
              <div className="w-full bg-gray-200 rounded-full h-2">
                <div
                  className="bg-green-500 h-2 rounded-full transition-all duration-1000"
                  style={{ width: `${metrics.penetracion_bruta}%` }}
                ></div>
              </div>
              <p className="text-sm text-gray-600 flex items-center justify-between">
                <span><strong>{metrics.ventas}</strong> ventas cerradas</span>
                <span className="text-xs text-gray-400">de {metrics.total_gestiones}</span>
              </p>
            </div>
          </div>

          {/* Penetración Neta */}
          <div className="bg-white p-6 rounded-xl shadow-lg hover:shadow-xl transition-shadow border-l-4 border-purple-500">
            <div className="flex items-center justify-between mb-4">
              <h3 className="text-lg font-semibold text-gray-700">Penetración Neta</h3>
              <span className="text-xs bg-purple-100 text-purple-800 px-2 py-1 rounded-full">
                Efectiva
              </span>
            </div>
            <div className="space-y-2">
              <div className="flex items-baseline">
                <p className="text-3xl font-bold text-purple-600">{metrics.penetracion_neta.toFixed(1)}%</p>
              </div>
              <div className="w-full bg-gray-200 rounded-full h-2">
                <div
                  className="bg-purple-500 h-2 rounded-full transition-all duration-1000"
                  style={{ width: `${Math.min(metrics.penetracion_neta, 100)}%` }}
                ></div>
              </div>
              <p className="text-sm text-gray-600 flex items-center justify-between">
                <span><strong>{metrics.ventas}</strong> de contactados</span>
                <span className="text-xs text-gray-400">{metrics.gestiones_con_contacto} efectivos</span>
              </p>
            </div>
          </div>
        </div>
      )}

      {/* Enhanced Save Snapshot */}
      {metrics && (
        <div className="bg-white p-6 rounded-xl shadow-lg border-l-4 border-green-500">
          <div className="mb-4">
            <h2 className="text-xl font-semibold text-gray-800">Guardar Snapshot</h2>
          </div>
          <p className="text-gray-600 mb-4">Guarda el estado actual de las métricas con los filtros aplicados</p>
          <div className="flex gap-4">
            <input
              type="text"
              value={snapshotName}
              onChange={(e) => setSnapshotName(e.target.value)}
              placeholder="Ej: Métricas Q1 2025"
              className="flex-1 border border-gray-300 rounded-lg px-4 py-2 focus:ring-2 focus:ring-green-500 focus:border-green-500 transition-colors"
            />
            <button
              onClick={saveSnapshot}
              disabled={!snapshotName.trim()}
              className="bg-gradient-to-r from-green-600 to-green-700 text-white px-6 py-2 rounded-lg hover:from-green-700 hover:to-green-800 disabled:opacity-50 disabled:cursor-not-allowed transition-all duration-200 shadow-lg"
            >
              Guardar Snapshot
            </button>
          </div>
        </div>
      )}

      {/* Enhanced Snapshots List */}
      <div className="bg-white p-6 rounded-xl shadow-lg">
        <div className="flex items-center justify-between mb-6">
          <h2 className="text-xl font-semibold text-gray-800">Snapshots Guardados</h2>
          <span className="text-sm bg-purple-100 text-purple-800 px-3 py-1 rounded-full">
            {snapshots.length} snapshots
          </span>
        </div>

        {snapshots.length === 0 ? (
          <div className="text-center py-12 text-gray-500">
            <p className="mt-4">No hay snapshots guardados</p>
            <p className="text-sm">Guarda tu primer snapshot para hacer seguimiento histórico</p>
          </div>
        ) : (
          <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
            {snapshots.map(snapshot => (
              <div key={snapshot.id} className="border border-gray-200 rounded-lg p-4 hover:shadow-md transition-shadow">
                <div className="flex justify-between items-start mb-3">
                  <div className="flex-1">
                    <h3 className="font-semibold text-gray-900">
                      {snapshot.name}
                    </h3>
                    <p className="text-xs text-gray-500 mt-1">
                      {new Date(snapshot.created_at).toLocaleString('es-ES')}
                    </p>
                  </div>
                </div>

                <div className="grid grid-cols-3 gap-3 mt-4">
                  <div className="text-center bg-blue-50 rounded-lg p-2">
                    <div className="text-xs text-blue-600 font-medium">Contactabilidad</div>
                    <div className="text-lg font-bold text-blue-700">
                      {snapshot.metrics.contactabilidad.toFixed(1)}%
                    </div>
                  </div>
                  <div className="text-center bg-green-50 rounded-lg p-2">
                    <div className="text-xs text-green-600 font-medium">P. Bruta</div>
                    <div className="text-lg font-bold text-green-700">
                      {snapshot.metrics.penetracion_bruta.toFixed(1)}%
                    </div>
                  </div>
                  <div className="text-center bg-purple-50 rounded-lg p-2">
                    <div className="text-xs text-purple-600 font-medium">P. Neta</div>
                    <div className="text-lg font-bold text-purple-700">
                      {snapshot.metrics.penetracion_neta.toFixed(1)}%
                    </div>
                  </div>
                </div>

                <div className="mt-3 text-xs text-gray-500 flex justify-between">
                  <span>{snapshot.metrics.total_gestiones} gestiones</span>
                  <span>{snapshot.metrics.ventas} ventas</span>
                </div>
              </div>
            ))}
          </div>
        )}
      </div>
      </div>
    </div>
  )
}