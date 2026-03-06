"""Pydantic models for the ticketing API."""

from datetime import datetime
from enum import Enum
from typing import Optional

from pydantic import BaseModel


class Zone(str, Enum):
    """Transport zone enumeration (HSL-style)."""

    AB = "AB"
    ABC = "ABC"
    ABCD = "ABCD"
    BC = "BC"
    CD = "CD"


class TicketCreate(BaseModel):
    """Request model for creating a ticket."""

    zone: Zone = Zone.AB


class Ticket(BaseModel):
    """Ticket response model."""

    id: str
    zone: str
    created_at: datetime
    valid: bool = True
    validated: Optional[datetime] = None


class ValidationRequest(BaseModel):
    """Request model for ticket validation."""

    ticket_id: str


class ValidationResponse(BaseModel):
    """Response model for ticket validation."""

    ticket_id: str
    valid: bool
    status: str
    validated: Optional[datetime] = None


class ZoneInfo(BaseModel):
    """Zone information model."""

    id: str
    name: str
    description: str
