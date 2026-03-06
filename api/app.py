"""FastAPI ticketing API - simulates a public transport ticketing backend."""

import uuid
from datetime import datetime
from typing import Dict

from fastapi import FastAPI, HTTPException

from .models import (
    Ticket,
    TicketCreate,
    TicketType,
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


@app.post("/tickets", response_model=Ticket)
def create_ticket(ticket_data: TicketCreate):
    """Create a new ticket."""
    ticket_id = str(uuid.uuid4())
    ticket = {
        "id": ticket_id,
        "ticket_type": ticket_data.ticket_type.value,
        "zone": ticket_data.zone.value,
        "passenger_type": ticket_data.passenger_type,
        "created_at": datetime.utcnow(),
        "validated_at": None,
        "valid": True,
    }
    tickets[ticket_id] = ticket
    return ticket


@app.get("/tickets/{ticket_id}", response_model=Ticket)
def get_ticket(ticket_id: str):
    """Retrieve a ticket by ID."""
    if ticket_id not in tickets:
        raise HTTPException(status_code=404, detail="Ticket not found")
    return tickets[ticket_id]


@app.post("/validate", response_model=ValidationResponse)
def validate_ticket(request: ValidationRequest):
    """Validate a ticket (simulates validator scan)."""
    if request.ticket_id not in tickets:
        raise HTTPException(status_code=404, detail="Ticket not found")

    ticket = tickets[request.ticket_id]
    now = datetime.utcnow()

    if not ticket["valid"]:
        return ValidationResponse(
            ticket_id=request.ticket_id,
            valid=False,
            message="Ticket has already been used",
            validated_at=ticket.get("validated_at"),
        )

    # Mark as validated
    ticket["validated_at"] = now
    ticket["valid"] = False

    return ValidationResponse(
        ticket_id=request.ticket_id,
        valid=True,
        message="Ticket validated successfully",
        validated_at=now,
    )


@app.get("/zones")
def get_zones():
    """Get available transport zones."""
    return {"zones": [z.model_dump() for z in ZONES]}


@app.delete("/tickets")
def clear_tickets():
    """Clear all tickets (for testing purposes)."""
    tickets.clear()
    return {"message": "All tickets cleared"}
