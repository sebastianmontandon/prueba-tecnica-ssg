import './globals.css'
import type { Metadata } from 'next'

export const metadata: Metadata = {
  title: 'CRM Dashboard',
  description: 'Dashboard de métricas CRM',
}

export default function RootLayout({
  children,
}: {
  children: React.ReactNode
}) {
  return (
    <html lang="es">
      <body>{children}</body>
    </html>
  )
}