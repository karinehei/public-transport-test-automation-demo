# API stage - FastAPI backend
FROM python:3.12-slim AS api
WORKDIR /app
COPY api/requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
COPY api/ ./
EXPOSE 8000
CMD ["uvicorn", "app:app", "--host", "0.0.0.0", "--port", "8000"]

# Frontend stage - React + Vite
FROM node:20-alpine AS frontend
WORKDIR /app
COPY frontend/package.json ./
RUN npm install
COPY frontend/ ./
RUN npm run build

# Serve frontend with nginx (proxies /api to backend)
FROM nginx:alpine AS frontend-serve
COPY --from=frontend /app/dist /usr/share/nginx/html
COPY frontend/nginx.conf /etc/nginx/conf.d/default.conf
EXPOSE 80

# Test stage - Robot Framework
FROM python:3.12-slim AS test
WORKDIR /workspace
# Install Chrome and chromedriver for Selenium UI tests
RUN apt-get update && apt-get install -y --no-install-recommends \
    chromium \
    chromium-driver \
    && rm -rf /var/lib/apt/lists/*
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
# Exclude UI tests by default (need frontend); run full suite with: robot --variable APP_URL:http://frontend tests/
CMD ["robot", "--exclude", "ui", "--variable", "API_BASE_URL:http://api:8000", "--outputdir", "results", "tests/"]
