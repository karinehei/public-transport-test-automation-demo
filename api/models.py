"""Pydantic models for the ticketing API."""

from datetime import datetime
from enum import Enum
from typing import Optional

from pydantic import BaseModel, Field


class TicketType(str, Enum):
    """Ticket type enumeration."""

    SINGLE = "single"
    DAY = "day"
    WEEK = "week"
    MONTH = "month"


class Zone(str, Enum):
    """Transport zone enumeration (HSL-style)."""

    AB = "AB"
    ABC = "ABC"
    ABCD = "ABCD"
    BC = "BC"
    CD = "CD"


class TicketCreate(BaseModel):
    """Request model for creating a ticket."""

    ticket_type: TicketType = TicketType.SINGLE
    zone: Zone = Zone.AB
    passenger_type: str = "adult"


class Ticket(BaseModel):
    """Ticket response model."""

    id: str
    ticket_type: TicketType
    zone: Zone
    passenger_type: str
    created_at: datetime
    validated_at: Optional[datetime] = None
    valid: bool = True


class ValidationRequest(BaseModel):
    """Request model for ticket validation."""

    ticket_id: str


class ValidationResponse(BaseModel):
    """Response model for ticket validation."""

    ticket_id: str
    valid: bool
    message: str
    validated_at: Optional[datetime] = None


class ZoneInfo(BaseModel):
    """Zone information model."""

    id: str
    name: str
    description: str
