# Test Suites – Public Transport Ticketing System

Test suites are organized by test level and purpose. In Azure Test Plans, these map to Test Suites; in Robot Framework, they map to directories and tags.

## Suite Overview

| Suite | Purpose | Robot Path | Tags | Automation |
|-------|---------|------------|------|------------|
| Smoke Tests | Critical path validation | tests/e2e/, tests/ui/ | smoke, critical | ✅ |
| API Tests | API contract and behaviour | tests/api/ | - | ✅ |
| UI Tests | Web UI flows | tests/ui/ | ui, e2e | ✅ |
| End-to-End Tests | Full user journey | tests/e2e/ | e2e, smoke | ✅ |
| Regression Tests | Full suite | tests/ | - | ✅ |

## 1. Smoke Tests

**Purpose**: Fast validation of critical flows; run on every commit/PR.

**Scope**:
- API health check
- Get zones
- Buy ticket
- Validate ticket
- UI: Complete purchase and validation flow

**Robot Framework**:
- `tests/e2e/ticket_flow.robot` (tag: smoke, critical)
- `tests/ui/buy_ticket.robot` (tag: smoke)

**Execution**: `robot --include smoke tests/`

## 2. API Tests

**Purpose**: Verify REST API endpoints and responses.

**Scope**:
- GET /zones
- POST /tickets
- GET /tickets/{id}
- POST /validate
- GET /health

**Robot Framework**: `tests/api/ticket_api.robot`

**Test Cases**:
- Get Zones
- Purchase Ticket
- Fetch Ticket
- Validate Ticket

**Execution**: `robot --exclude ui tests/api/`

## 3. UI Tests

**Purpose**: Verify web UI behaviour via Selenium.

**Scope**:
- Open application
- Select zone
- Buy ticket
- Confirm ticket created
- Validate ticket
- Confirm validation result

**Robot Framework**: `tests/ui/buy_ticket.robot`

**Execution**: `robot --include ui tests/`

## 4. End-to-End Tests

**Purpose**: Full user journey via API (no browser).

**Scope**:
- Get zones → Buy ticket → Retrieve ticket → Validate ticket
- Verify ticket invalidated after validation

**Robot Framework**: `tests/e2e/ticket_flow.robot`

**Execution**: `robot --exclude ui tests/e2e/`

## 5. Regression Tests

**Purpose**: Full automated suite; run before release.

**Scope**: All API, UI, and E2E tests.

**Execution**: `robot tests/` (or `robot --exclude ui tests/` if UI not available)

## Azure Test Plans Mapping

| Azure Test Plan Suite | Robot Framework |
|-----------------------|-----------------|
| Smoke | --include smoke |
| API | tests/api/ |
| UI | --include ui |
| E2E | tests/e2e/ |
| Regression | tests/ |
