# Traceability Matrix – Public Transport Ticketing System

Links business requirements, test suites, test cases, and Robot Framework automation.

## Business Requirements (Example)

| Req ID | Requirement |
|--------|-------------|
| REQ-001 | System shall provide a list of available transport zones |
| REQ-002 | System shall allow purchase of a ticket for a selected zone |
| REQ-003 | System shall allow retrieval of a ticket by ID |
| REQ-004 | System shall allow validation of a ticket (one-time use) |
| REQ-005 | System shall provide a web UI for ticket purchase and validation |
| REQ-006 | System shall invalidate ticket after validation |

## Traceability Matrix

| Req ID | Test Suite | Test Case | Robot File | Test Name |
|--------|------------|-----------|------------|-----------|
| REQ-001 | API Tests | TC-API-001 | ticket_api.robot | Get Zones |
| REQ-001 | E2E Tests | TC-E2E-001 | ticket_flow.robot | Complete Ticket User Journey |
| REQ-002 | API Tests | TC-API-002 | ticket_api.robot | Purchase Ticket |
| REQ-002 | UI Tests | TC-UI-001 | buy_ticket.robot | Complete Ticket Purchase And Validation UI Flow |
| REQ-002 | E2E Tests | TC-E2E-001 | ticket_flow.robot | Complete Ticket User Journey |
| REQ-003 | API Tests | TC-API-003 | ticket_api.robot | Fetch Ticket |
| REQ-003 | E2E Tests | TC-E2E-001 | ticket_flow.robot | Complete Ticket User Journey |
| REQ-004 | API Tests | TC-API-004 | ticket_api.robot | Validate Ticket |
| REQ-004 | UI Tests | TC-UI-001 | buy_ticket.robot | Complete Ticket Purchase And Validation UI Flow |
| REQ-004 | E2E Tests | TC-E2E-001 | ticket_flow.robot | Complete Ticket User Journey |
| REQ-005 | UI Tests | TC-UI-001 | buy_ticket.robot | Complete Ticket Purchase And Validation UI Flow |
| REQ-006 | API Tests | TC-API-004 | ticket_api.robot | Validate Ticket |
| REQ-006 | E2E Tests | TC-E2E-001 | ticket_flow.robot | Complete Ticket User Journey |

## Coverage Summary

| Requirement | API | UI | E2E |
|-------------|-----|-----|-----|
| REQ-001 | ✅ | - | ✅ |
| REQ-002 | ✅ | ✅ | ✅ |
| REQ-003 | ✅ | - | ✅ |
| REQ-004 | ✅ | ✅ | ✅ |
| REQ-005 | - | ✅ | - |
| REQ-006 | ✅ | - | ✅ |

## Azure Test Plans Integration

In Azure Test Plans:

1. Create work items for requirements (REQ-001 to REQ-006)
2. Create test cases (TC-API-001, etc.) and link to requirements
3. Associate automated tests with test cases (via test case ID or naming convention)
4. Use the matrix view to track requirement coverage

## Robot Framework Mapping

| Robot File | Path | Test Cases |
|------------|------|------------|
| ticket_api.robot | tests/api/ | Get Zones, Purchase Ticket, Fetch Ticket, Validate Ticket |
| buy_ticket.robot | tests/ui/ | Complete Ticket Purchase And Validation UI Flow |
| ticket_flow.robot | tests/e2e/ | Complete Ticket User Journey |
