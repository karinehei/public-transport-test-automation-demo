# API stage - FastAPI backend
FROM python:3.12-slim AS api
WORKDIR /app
COPY api/requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
COPY api/ ./
EXPOSE 8000
CMD ["uvicorn", "app:app", "--host", "0.0.0.0", "--port", "8000"]

# Test stage - Robot Framework
FROM python:3.12-slim AS test
WORKDIR /workspace
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
# Tests run automatically; project mounted via volume, API via depends_on + healthcheck
CMD ["robot", "--variable", "API_BASE_URL:http://api:8000", "--outputdir", "results", "tests/"]
