"""FastAPI ticketing API - simulates a public transport ticket system."""

import uuid
from datetime import datetime
from typing import Dict

from fastapi import FastAPI, HTTPException

from models import (
    Ticket,
    TicketCreate,
    ValidationRequest,
    ValidationResponse,
    Zone,
    ZoneInfo,
)

app = FastAPI(
    title="Public Transport Ticketing API",
    description="Demo API simulating HSL-style ticketing system",
    version="1.0.0",
)

# In-memory ticket storage
tickets: Dict[str, dict] = {}

# Zone definitions (HSL-style)
ZONES = [
    ZoneInfo(id="AB", name="Zone AB", description="Helsinki city center"),
    ZoneInfo(id="ABC", name="Zone ABC", description="Helsinki metropolitan area"),
    ZoneInfo(id="ABCD", name="Zone ABCD", description="Extended metropolitan area"),
    ZoneInfo(id="BC", name="Zone BC", description="Espoo, Vantaa"),
    ZoneInfo(id="CD", name="Zone CD", description="Outer suburbs"),
]


@app.get("/health")
def health_check():
    """Health check endpoint for Docker/CI."""
    return {"status": "healthy", "service": "ticketing-api"}


@app.get("/tickets")
def list_tickets():
    """List all tickets (for browser/API exploration)."""
    return {"tickets": list(tickets.values())}


@app.post("/tickets", response_model=Ticket, status_code=201)
def create_ticket(ticket_data: TicketCreate):
    """Create a ticket with zone and return ticket_id."""
    ticket_id = str(uuid.uuid4())
    ticket = {
        "id": ticket_id,
        "zone": ticket_data.zone.value,
        "created_at": datetime.utcnow(),
        "valid": True,
        "validated": None,
    }
    tickets[ticket_id] = ticket
    return ticket


@app.get("/tickets/{ticket_id}", response_model=Ticket)
def get_ticket(ticket_id: str):
    """Return ticket information."""
    if ticket_id not in tickets:
        raise HTTPException(status_code=404, detail="Ticket not found")
    return tickets[ticket_id]


@app.post("/validate", response_model=ValidationResponse)
def validate_ticket(request: ValidationRequest):
    """Validate a ticket and return status."""
    if request.ticket_id not in tickets:
        raise HTTPException(status_code=404, detail="Ticket not found")

    ticket = tickets[request.ticket_id]
    now = datetime.utcnow()

    if not ticket["valid"]:
        return ValidationResponse(
            ticket_id=request.ticket_id,
            valid=False,
            status="already_used",
            validated=ticket.get("validated"),
        )

    # Mark as validated
    ticket["validated"] = now
    ticket["valid"] = False

    return ValidationResponse(
        ticket_id=request.ticket_id,
        valid=True,
        status="validated",
        validated=now,
    )


@app.get("/zones")
def get_zones():
    """Return available travel zones."""
    return {"zones": [z.model_dump() for z in ZONES]}


@app.delete("/tickets")
def clear_tickets():
    """Clear all tickets (for testing purposes)."""
    tickets.clear()
    return {"message": "All tickets cleared"}
