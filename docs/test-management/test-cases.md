# Test Cases – Public Transport Ticketing System

Structured test cases with IDs, steps, and automation references.

---

## API Test Cases

### TC-API-001: Get Zones

| Field | Value |
|-------|-------|
| **ID** | TC-API-001 |
| **Title** | Retrieve available travel zones |
| **Description** | Verify GET /zones returns valid zone list (AB, ABC, ABCD, BC, CD) |
| **Preconditions** | API is running and healthy |
| **Steps** | 1. Call GET /zones<br>2. Verify status 200<br>3. Verify response contains zones array<br>4. Verify each zone has id and name<br>5. Verify zone ids are valid |
| **Expected Result** | 200 OK; zones array with valid structure |
| **Automation** | Automated |
| **Robot File** | tests/api/ticket_api.robot – Get Zones |

---

### TC-API-002: Purchase Ticket

| Field | Value |
|-------|-------|
| **ID** | TC-API-002 |
| **Title** | Create ticket (purchase) for zone AB |
| **Description** | Verify POST /tickets creates a valid ticket |
| **Preconditions** | API is running |
| **Steps** | 1. Call POST /tickets with zone=AB<br>2. Verify status 201<br>3. Verify response has id, zone, created_at, valid<br>4. Verify zone=AB, valid=True |
| **Expected Result** | 201 Created; ticket with valid structure |
| **Automation** | Automated |
| **Robot File** | tests/api/ticket_api.robot – Purchase Ticket |

---

### TC-API-003: Fetch Ticket

| Field | Value |
|-------|-------|
| **ID** | TC-API-003 |
| **Title** | Retrieve ticket by ID |
| **Description** | Purchase ticket, then fetch it by ID and validate response |
| **Preconditions** | API is running |
| **Steps** | 1. Purchase ticket for zone ABC<br>2. Call GET /tickets/{ticket_id}<br>3. Verify status 200<br>4. Verify id, zone, created_at, valid match |
| **Expected Result** | 200 OK; ticket data matches |
| **Automation** | Automated |
| **Robot File** | tests/api/ticket_api.robot – Fetch Ticket |

---

### TC-API-004: Validate Ticket

| Field | Value |
|-------|-------|
| **ID** | TC-API-004 |
| **Title** | Validate ticket and verify invalidation |
| **Description** | Purchase ticket, validate it, verify status and that ticket becomes invalid |
| **Preconditions** | API is running |
| **Steps** | 1. Purchase ticket for zone AB<br>2. Call POST /validate with ticket_id<br>3. Verify status 200, valid=True, status=validated<br>4. Call GET /tickets/{id}<br>5. Verify valid=False |
| **Expected Result** | Validation succeeds; ticket marked invalid |
| **Automation** | Automated |
| **Robot File** | tests/api/ticket_api.robot – Validate Ticket |

---

## UI Test Cases

### TC-UI-001: Complete Ticket Purchase And Validation UI Flow

| Field | Value |
|-------|-------|
| **ID** | TC-UI-001 |
| **Title** | E2E UI: Buy and validate ticket via web UI |
| **Description** | Open app, select zone, buy ticket, confirm, validate, confirm result |
| **Preconditions** | API and frontend running; browser available |
| **Steps** | 1. Open ticketing application<br>2. Select zone AB<br>3. Click Buy Ticket<br>4. Confirm ticket card displayed<br>5. Click Validate Ticket<br>6. Confirm validation success message |
| **Expected Result** | Ticket purchased and validated successfully |
| **Automation** | Automated |
| **Robot File** | tests/ui/buy_ticket.robot – Complete Ticket Purchase And Validation UI Flow |

---

## E2E Test Cases

### TC-E2E-001: Complete Ticket User Journey

| Field | Value |
|-------|-------|
| **ID** | TC-E2E-001 |
| **Title** | Full user journey via API |
| **Description** | Get zones → buy ticket → retrieve → validate; verify ticket invalidated |
| **Preconditions** | API is running |
| **Steps** | 1. Get zones, verify 200<br>2. Buy ticket for AB, verify 201<br>3. Get ticket by ID, verify valid<br>4. Validate ticket, verify validated<br>5. Get ticket again, verify invalid |
| **Expected Result** | Full flow succeeds; ticket cannot be reused |
| **Automation** | Automated |
| **Robot File** | tests/e2e/ticket_flow.robot – Complete Ticket User Journey |

---

## Summary

| ID | Title | Robot File | Test Name |
|----|-------|------------|-----------|
| TC-API-001 | Get Zones | ticket_api.robot | Get Zones |
| TC-API-002 | Purchase Ticket | ticket_api.robot | Purchase Ticket |
| TC-API-003 | Fetch Ticket | ticket_api.robot | Fetch Ticket |
| TC-API-004 | Validate Ticket | ticket_api.robot | Validate Ticket |
| TC-UI-001 | Complete Ticket Purchase And Validation UI Flow | buy_ticket.robot | Complete Ticket Purchase And Validation UI Flow |
| TC-E2E-001 | Complete Ticket User Journey | ticket_flow.robot | Complete Ticket User Journey |
