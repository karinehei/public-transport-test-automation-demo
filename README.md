# Ticketing Test Automation Demo

Demo project simulating E2E test automation for a public transport ticketing system (HSL-style).

## Tech Stack

- **Python 3.12**
- **FastAPI** – ticketing API backend
- **Robot Framework** – test automation (RequestsLibrary)
- **Docker & Docker Compose** – containerized execution
- **GitHub Actions** – CI pipeline

## Project Structure

```
├── api/
│   ├── app.py           # FastAPI application
│   ├── models.py        # Pydantic models
│   └── requirements.txt
├── tests/
│   ├── api/             # API tests
│   │   └── ticket_api.robot
│   ├── ui/              # UI flow tests (API-backed)
│   │   └── buy_ticket.robot
│   └── e2e/             # End-to-end tests
│       └── ticket_flow.robot
├── resources/
│   └── keywords.robot  # Reusable keywords
├── .github/
│   └── workflows/
│       └── tests.yml   # GitHub Actions workflow
├── docker-compose.yml
├── Dockerfile
├── requirements.txt
└── README.md
```

## API Endpoints

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/health` | Health check |
| POST | `/tickets` | Create ticket |
| GET | `/tickets/{ticket_id}` | Get ticket by ID |
| POST | `/validate` | Validate ticket |
| GET | `/zones` | List transport zones |

### Zones (HSL-style)

- AB, ABC, ABCD, BC, CD

## Quick Start

### Local (without Docker)

1. **Create a virtual environment and install dependencies:**
   ```bash
   python3 -m venv .venv
   source .venv/bin/activate   # Linux/macOS
   # or:  .venv\Scripts\activate   # Windows

   pip install -r api/requirements.txt
   pip install -r requirements.txt
   ```

2. **Start the API:**
   ```bash
   cd api && uvicorn app:app --host 0.0.0.0 --port 8000
   ```

3. **Run tests** (in another terminal, with venv activated):
   ```bash
   robot tests/
   ```

### Docker Compose

1. **Start API only:**
   ```bash
   docker compose up -d api
   ```

2. **Run API + tests** (tests wait for API health, then run automatically):
   ```bash
   docker compose up
   ```

3. **Run tests only** (API must be running):
   ```bash
   docker compose run --rm tests
   ```

Test results are written to `results/` (report.html, log.html).

## CI (GitHub Actions)

The `tests.yml` workflow runs on every push to `main` or `master`:

1. Checkout repository
2. Set up Python 3.12
3. Install dependencies
4. Start API with Docker Compose
5. Wait for API health check
6. Run Robot Framework tests
7. Upload `report.html` and `log.html` as artifacts

Download artifacts from the Actions run page to view test reports.

## Example: Create and Validate Ticket

```bash
# Create ticket
curl -X POST http://localhost:8000/tickets \
  -H "Content-Type: application/json" \
  -d '{"zone": "AB"}'

# Validate (use ticket_id from response)
curl -X POST http://localhost:8000/validate \
  -H "Content-Type: application/json" \
  -d '{"ticket_id": "<ticket_id>"}'
```

## License

MIT
