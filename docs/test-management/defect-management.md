# Defect Management – Public Transport Ticketing System

Process for handling defects found by automated tests and manual testing.

## Defect Lifecycle

```
New → Active → Resolved → Closed
         ↓
      Deferred
```

| State | Description |
|-------|-------------|
| **New** | Defect reported, not yet triaged |
| **Active** | Accepted, assigned, in progress |
| **Resolved** | Fix implemented, awaiting verification |
| **Closed** | Verified and closed |
| **Deferred** | Postponed to a later release |

## Severity

| Severity | Definition | Example |
|----------|------------|---------|
| **Critical** | System unusable; core flow broken | API returns 500 for all requests |
| **High** | Major feature broken | Cannot validate tickets |
| **Medium** | Feature partially broken | Wrong zone displayed |
| **Low** | Minor issue; workaround exists | UI alignment issue |

## Priority

| Priority | Definition |
|----------|------------|
| **P1** | Fix before next release |
| **P2** | Fix in current sprint |
| **P3** | Fix when possible |
| **P4** | Backlog |

## Reporting Process for Automated Test Failures

### 1. Pipeline Failure

When a Robot Framework test fails in Azure DevOps:

1. **Pipeline** fails; results published to Test Results and artifacts
2. **Engineer** downloads log.html, report.html; reviews failure
3. **Triage**:
   - **Product defect**: Create work item (Bug), link to test case, assign to developer
   - **Test defect**: Fix test or environment; no bug
   - **Environment issue**: Retry or fix infrastructure

### 2. Bug Work Item

| Field | Value |
|-------|-------|
| Title | [Area] Short description |
| Description | Steps, expected, actual, environment |
| Severity | Critical / High / Medium / Low |
| Priority | P1–P4 |
| Links | Test case, requirement, pipeline run |
| Attachments | log.html, screenshot (for UI) |

### 3. Example Title

- `[API] POST /validate returns 500 for valid ticket`
- `[UI] Buy Ticket button not visible on mobile viewport`

## Triage Workflow

1. **Daily**: Review failed pipeline runs
2. **Triage meeting**: Classify new defects (severity, priority, assignee)
3. **Root cause**: Distinguish product vs test vs environment
4. **Link**: Bug ↔ Test Case ↔ Requirement
5. **Retest**: After fix, run automated tests; close when passing

## Automated Test Failure Handling

| Scenario | Action |
|----------|--------|
| Flaky test | Investigate; fix or quarantine |
| Environment down | Retry pipeline; fix infra |
| Product regression | Create bug; block release |
| Test outdated | Update test; no bug |

## Quality Gates

- **Release block**: Critical or High defects open
- **Sign-off**: All automated tests pass; no P1/P2 open
