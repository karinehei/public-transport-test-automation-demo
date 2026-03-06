# Ticketing Test Automation Demo

Demo project simulating E2E test automation for a public transport ticketing system (HSL-style).

## Tech Stack

- **Python 3.12**
- **FastAPI** – ticketing API backend
- **Robot Framework** – test automation
- **Docker & Docker Compose** – containerized execution
- **GitHub Actions** – CI pipeline

## Project Structure

```
ticketing-test-automation-demo/
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
│   └── keywords.robot   # Reusable keywords
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

### Ticket Types

- `single` – Single journey
- `day` – Day ticket
- `week` – Weekly ticket
- `month` – Monthly ticket

### Zones (HSL-style)

- AB, ABC, ABCD, BC, CD

## Quick Start

### Local (without Docker)

1. **Start the API:**
   ```bash
   pip install -r api/requirements.txt
   uvicorn api.app:app --reload
   ```

2. **Run tests:**
   ```bash
   pip install -r requirements.txt
   robot tests/
   ```

### Docker Compose

1. **Start API only:**
   ```bash
   docker compose up -d api
   ```

2. **Run tests in containers:**
   ```bash
   docker compose --profile test run --rm tests
   ```

3. **Full run (API + tests):**
   ```bash
   docker compose up api && docker compose --profile test run --rm tests
   ```

## CI (GitHub Actions)

On push/PR to `main` or `master`:

1. Start API with Docker Compose
2. Wait for health check
3. Run Robot Framework tests
4. Upload test results as artifacts

## Example: Create and Validate Ticket

```bash
# Create ticket
curl -X POST http://localhost:8000/tickets \
  -H "Content-Type: application/json" \
  -d '{"ticket_type": "single", "zone": "AB"}'

# Validate (use ticket_id from response)
curl -X POST http://localhost:8000/validate \
  -H "Content-Type: application/json" \
  -d '{"ticket_id": "<ticket_id>"}'
```

## License

MIT
