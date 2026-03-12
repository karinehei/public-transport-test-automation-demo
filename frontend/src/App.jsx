import { useState, useEffect } from 'react'

const API_URL = import.meta.env.VITE_API_URL || '/api'
const REPORTS_URL = import.meta.env.VITE_REPORTS_URL
const REPORTS_LINK = REPORTS_URL ? `${REPORTS_URL.replace(/\/$/, '')}/report.html` : 'https://github.com/karinehei/public-transport-test-automation-demo/actions'

export default function App() {
  const [zones, setZones] = useState([])
  const [selectedZone, setSelectedZone] = useState('AB')
  const [ticket, setTicket] = useState(null)
  const [validation, setValidation] = useState(null)
  const [loading, setLoading] = useState(false)
  const [error, setError] = useState(null)

  useEffect(() => {
    fetch(`${API_URL}/zones`)
      .then((res) => res.json())
      .then((data) => {
        setZones(data.zones || [])
        if (data.zones?.length && !selectedZone) {
          setSelectedZone(data.zones[0].id)
        }
      })
      .catch(() => setError('Failed to load zones'))
  }, [])

  const buyTicket = () => {
    setLoading(true)
    setError(null)
    setValidation(null)
    fetch(`${API_URL}/tickets`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ zone: selectedZone }),
    })
      .then((res) => res.json())
      .then((data) => {
        setTicket(data)
        setLoading(false)
      })
      .catch(() => {
        setError('Failed to buy ticket')
        setLoading(false)
      })
  }

  const validateTicket = () => {
    if (!ticket?.id) return
    setLoading(true)
    setError(null)
    fetch(`${API_URL}/validate`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ ticket_id: ticket.id }),
    })
      .then((res) => res.json())
      .then((data) => {
        setValidation(data)
        setTicket((prev) => (prev ? { ...prev, valid: data.valid } : null))
        setLoading(false)
      })
      .catch(() => {
        setError('Failed to validate ticket')
        setLoading(false)
      })
  }

  const reset = () => {
    setTicket(null)
    setValidation(null)
    setError(null)
  }

  return (
    <div className="app" data-testid="ticketing-app">
      <h1>Public Transport Tickets</h1>

      <div className="section">
        <label htmlFor="zone-select">Select travel zone</label>
        <select
          id="zone-select"
          data-testid="zone-select"
          value={selectedZone}
          onChange={(e) => setSelectedZone(e.target.value)}
          disabled={!!ticket}
        >
          {zones.map((z) => (
            <option key={z.id} value={z.id}>
              {z.name} – {z.description}
            </option>
          ))}
        </select>
      </div>

      {!ticket ? (
        <button
          className="primary"
          data-testid="buy-ticket-btn"
          onClick={buyTicket}
          disabled={loading}
        >
          {loading ? 'Buying...' : 'Buy Ticket'}
        </button>
      ) : (
        <>
          <div className="ticket-card" data-testid="ticket-card">
            <p className="ticket-id" data-testid="ticket-id">
              Ticket ID: {ticket.id}
            </p>
            <p data-testid="ticket-zone">Zone: {ticket.zone}</p>
            <p data-testid="ticket-status">
              Status: {ticket.valid ? 'Valid' : 'Used'}
            </p>
          </div>

          {!validation ? (
            <button
              className="primary"
              data-testid="validate-ticket-btn"
              onClick={validateTicket}
              disabled={loading || !ticket.valid}
            >
              {loading ? 'Validating...' : 'Validate Ticket'}
            </button>
          ) : (
            <div
              className={`status ${validation.valid ? 'valid' : 'invalid'}`}
              data-testid="validation-result"
            >
              {validation.valid
                ? 'Ticket validated successfully'
                : 'Ticket has already been used'}
            </div>
          )}

          <button
            className="secondary"
            data-testid="buy-another-btn"
            onClick={reset}
            style={{ marginTop: '1rem' }}
          >
            Buy Another Ticket
          </button>
        </>
      )}

      {error && (
        <div className="error" data-testid="error-message">
          {error}
        </div>
      )}

      <a
        href={REPORTS_LINK}
        target="_blank"
        rel="noopener noreferrer"
        className="reports-link"
        data-testid="test-reports-link"
      >
        Test reports
      </a>
    </div>
  )
}
