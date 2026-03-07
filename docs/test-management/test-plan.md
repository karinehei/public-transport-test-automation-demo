# Test Plan – Public Transport Ticketing System

## 1. Scope

### In Scope

- **Ticketing API**: Create, retrieve, validate tickets; list zones; health check
- **Web UI**: Zone selection, buy ticket, validate ticket
- **End-to-end flows**: Full user journey from zones to validation
- **Environments**: dev, test, staging

### Out of Scope

- Payment gateway integration
- Mobile app
- Offline validation
- Performance/load testing (separate plan)

## 2. Objectives

- Verify API correctness for ticket lifecycle
- Verify UI functionality for purchase and validation
- Ensure E2E flows work across API and UI
- Provide automated regression coverage
- Support traceability from requirements to tests

## 3. Test Levels

| Level | Description | Tool | Location |
|-------|-------------|------|----------|
| **API** | REST API contract and behaviour | Robot Framework, RequestsLibrary | tests/api/ |
| **UI** | Web UI flows (Selenium) | Robot Framework, SeleniumLibrary | tests/ui/ |
| **E2E** | Full user journey via API | Robot Framework, RequestsLibrary | tests/e2e/ |

## 4. Environments

| Environment | Purpose | URL (example) |
|-------------|---------|----------------|
| dev | Local development | localhost:8000, localhost:5173 |
| test | CI pipeline | localhost (Docker) |
| staging | Pre-production | api-staging.example.com |

## 5. Entry Criteria

- API and frontend deployable via Docker Compose
- Test framework dependencies installed (Robot Framework, RequestsLibrary, SeleniumLibrary)
- Variable groups configured (API_BASE_URL, APP_URL)
- Azure DevOps pipeline configured (if using CI)

## 6. Exit Criteria

- All automated tests pass in CI
- No critical or high-severity defects open for release
- Test results published (log.html, report.html) and available in Azure DevOps
- Traceability matrix updated

## 7. Reporting

- **Azure DevOps Test Results**: JUnit output from Robot Framework
- **Pipeline Artifacts**: log.html, report.html, output.xml
- **Test Plans**: Test cases linked to requirements (see traceability-matrix.md)
- **Defects**: Linked to failing tests and requirements

## 8. Responsibilities

| Role | Responsibility |
|------|----------------|
| Test Automation Engineer | Maintain Robot Framework tests, CI pipeline, reporting |
| Developer | Fix defects, maintain API and UI |
| QA Lead | Test plan approval, release sign-off |
| DevOps | Infrastructure, environments, pipeline runs |
