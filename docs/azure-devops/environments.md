# Environments

This document describes the environment strategy for the Public Transport Ticketing Test Automation project.

## Environment Approach

| Environment | Purpose | Services | Typical Use |
|-------------|---------|----------|-------------|
| **dev** | Development and quick validation | API, frontend (local or container) | Developer runs tests locally |
| **test** | CI pipeline test execution | Docker Compose (API + frontend) | Azure DevOps pipeline |
| **staging** | Pre-production validation | Deployed stack | Manual or scheduled runs |

## Environment-Specific Variables

### Dev (Local)

| Variable | Value |
|----------|-------|
| API_BASE_URL | http://localhost:8000 |
| APP_URL | http://localhost:5173 (Vite dev server) or http://localhost:3000 |

### Test (CI Pipeline)

| Variable | Value |
|----------|-------|
| API_BASE_URL | http://localhost:8000 (or http://api:8000 in Docker network) |
| APP_URL | http://localhost:3000 |

### Staging

| Variable | Value |
|----------|-------|
| API_BASE_URL | https://api-staging.example.com |
| APP_URL | https://app-staging.example.com |

## Container Usage

### CI Pipeline (test environment)

The Azure DevOps pipeline uses Docker Compose to spin up services:

```yaml
# API tests: API only
docker compose up -d api

# UI tests: API + frontend
docker compose up -d api frontend
```

- **API**: FastAPI backend, port 8000
- **Frontend**: Nginx serving built React app, port 3000
- **Tests**: Run on the host agent with `localhost` URLs

### Docker Compose Services

| Service | Port | Health Check |
|---------|------|--------------|
| api | 8000 | GET /health |
| frontend | 3000 | (depends on api) |
| tests | - | Runs robot, exits |
| tests-ui | - | Runs robot with --include ui |

## Test Execution Flow

### Local (Developer)

1. Start API: `cd api && uvicorn app:app --port 8000`
2. Run API + E2E tests: `robot --exclude ui tests/`
3. (Optional) Start frontend: `cd frontend && npm run dev`
4. Run UI tests: `robot --include ui --variable APP_URL:http://localhost:5173 tests/`

### Docker Compose

1. API only: `docker compose up -d api`
2. Run tests: `docker compose run --rm tests`
3. Full stack + UI tests: `docker compose --profile ui-tests up`

### Azure DevOps Pipeline

1. **Build** stage: Start API
2. **API Tests** job: Start API → run API tests → publish
3. **UI Tests** job: Start API + frontend → run UI tests → publish
4. **E2E Tests** job: Start API → run E2E tests → publish

Each job runs on a fresh agent; containers are started per job.

## Test Isolation and Repeatability

- **API tests**: Each run creates new tickets; no shared state
- **UI tests**: Fresh browser session per run
- **E2E tests**: Full flow (zones → buy → validate) in a single test; no cross-test dependencies
- **Data**: No persistent database in test; in-memory storage is reset per API restart

## Extending for Staging

To run tests against a deployed staging environment:

1. Create variable group `Ticketing-Test-Config-Staging` with staging URLs
2. Add a pipeline stage that uses the staging variable group
3. Optionally add an Azure DevOps Environment `staging` with approval gates
4. Run the same Robot Framework tests with `--variable API_BASE_URL:$(API_BASE_URL)` from the variable group
