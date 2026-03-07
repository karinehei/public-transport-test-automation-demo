# Pipeline Architecture

This document describes the Azure DevOps CI/CD pipeline for the Public Transport Ticketing Test Automation project.

## Overview

The pipeline runs Robot Framework tests (API, UI, E2E) in separate stages, publishes results to Azure DevOps Test Results, and produces downloadable artifacts (log.html, report.html, output.xml).

## Stages

```
┌─────────────┐
│   Build     │  Install deps, start API container
└──────┬──────┘
       │
       ├──────────────────────────────────────────┐
       │                                          │
       ▼                  ▼                       ▼
┌─────────────┐   ┌─────────────┐   ┌─────────────┐
│ API Tests   │   │ UI Tests    │   │ E2E Tests   │
│ (parallel)  │   │ (parallel)  │   │ (parallel)  │
└─────────────┘   └─────────────┘   └─────────────┘
       │                  │                       │
       └──────────────────┴───────────────────────┘
                          │
                          ▼
              PublishTestResults (each job)
              PublishPipelineArtifact (each job)
```

### Stage 1: Build

- **Purpose**: Prepare environment and start services
- **Steps**: Python setup, pip install, `docker compose up -d api`
- **Output**: API container running and healthy

### Stage 2: API Tests

- **Purpose**: Run Robot Framework API tests (`tests/api/`)
- **Trigger**: Depends on Build
- **Steps**:
  1. Start API container
  2. Run `robot --exclude ui tests/api/`
  3. Convert output.xml to JUnit via `rebot --xunit`
  4. PublishTestResults (JUnit)
  5. PublishPipelineArtifact (log.html, report.html, output.xml)

### Stage 3: UI Tests

- **Purpose**: Run Selenium-based UI tests (`tests/ui/`, `--include ui`)
- **Trigger**: Depends on Build
- **Steps**:
  1. Start API + frontend containers
  2. Run `robot --include ui tests/`
  3. Convert to JUnit, publish results and artifacts

### Stage 4: E2E Tests

- **Purpose**: Run end-to-end API flow tests (`tests/e2e/`)
- **Trigger**: Depends on Build
- **Steps**:
  1. Start API container
  2. Run `robot --exclude ui tests/e2e/`
  3. Convert to JUnit, publish results and artifacts

## Robot Framework Test Execution

| Test Type | Directory | Tags | Command |
|-----------|-----------|------|---------|
| API | tests/api/ | (none) | `robot --exclude ui tests/api/` |
| UI | tests/ | ui | `robot --include ui tests/` |
| E2E | tests/e2e/ | e2e, smoke | `robot --exclude ui tests/e2e/` |

### Variables

- **API_BASE_URL**: `http://localhost:8000` (from variable group or default)
- **APP_URL**: `http://localhost:3000` (for UI tests)

## Result Publishing

### 1. Azure DevOps Test Results

- **Task**: PublishTestResults@2
- **Format**: JUnit (converted from Robot output.xml via `rebot --xunit`)
- **Location**: Pipelines → Runs → Tests tab
- **Use**: Test trends, failure analysis, integration with Test Plans

### 2. Pipeline Artifacts

- **Artifacts**: `robot-api-results`, `robot-ui-results`, `robot-e2e-results`
- **Contents**: log.html, report.html, output.xml
- **Download**: Pipelines → Runs → Artifacts

## Quality Gates

### Current Behavior

- Each test stage fails the pipeline if tests fail (`failTaskOnFailedTests: true`)
- Stages run in parallel (API, UI, E2E) after Build

### Extending with Quality Gates

1. **Minimum pass rate**:
   ```yaml
   - script: |
       FAILED=$(robot --outputdir /tmp/out tests/ 2>&1 | grep "FAILED" || true)
       if [ -n "$FAILED" ]; then exit 1; fi
   ```

2. **Approval gates**: Add Azure DevOps Environments with approval requirements before deploying to staging.

3. **Test impact**: Use Azure Test Plans to link automated tests to requirements; block release if critical tests fail.

4. **Flaky test handling**: Re-run failed tests in a separate job; mark as flaky if they pass on retry.

## Triggers

- **Branches**: main, develop
- **Paths excluded**: docs/**, *.md, .gitignore
- **PR**: Same branches

## Variable Group

The pipeline uses `Ticketing-Test-Config` (provisioned by Terraform) for:

- API_BASE_URL
- APP_URL
- ROBOT_OUTPUT_DIR
- PYTHON_VERSION

Override per branch or environment as needed.
