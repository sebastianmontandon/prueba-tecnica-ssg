'use client'

import { useState, useEffect } from 'react'
import Dashboard from '../components/Dashboard'

export default function Home() {
  return (
    <main className="min-h-screen bg-gray-100">
      <div className="container mx-auto py-8">
        <h1 className="text-3xl font-bold text-gray-900 mb-8 text-center">
          CRM Dashboard
        </h1>
        <Dashboard />
      </div>
    </main>
  )
}