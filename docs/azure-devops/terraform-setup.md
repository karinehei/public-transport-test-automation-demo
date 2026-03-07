# Terraform Setup for Azure DevOps

This document explains how Terraform is used to provision and manage Azure DevOps resources for the Public Transport Ticketing Test Automation project.

## What Terraform Manages

| Resource | Managed | Description |
|----------|---------|-------------|
| **Project** | ✅ | Azure DevOps project with Agile template, all features enabled (Boards, Repos, Pipelines, Test Plans, Artifacts) |
| **Environments** | ✅ | dev, test, staging – used for deployment stages and approval gates |
| **Variable Groups** | ✅ | `Ticketing-Test-Config` – API_BASE_URL, APP_URL, ROBOT_OUTPUT_DIR, PYTHON_VERSION |
| **Build Pipeline** | ✅ | Pipeline definition referencing `azure-pipelines.yml` in the repository |
| **YAML Pipeline** | ❌ | Version-controlled in repo – source of truth for stages and jobs |
| **Service Connections** | ❌ | Documented; create manually or extend Terraform with `azuredevops_serviceendpoint_*` |
| **Test Plans / Suites** | ❌ | Use Azure Test Plans UI or REST API; see [test-management](../test-management/) docs |

## Resource Organization

```
Azure DevOps Organization
└── Project: TicketingTestAutomation
    ├── Repositories (default repo created with project)
    ├── Pipelines
    │   └── tta-ci-tests (references azure-pipelines.yml)
    ├── Variable Groups
    │   └── Ticketing-Test-Config
    └── Environments
        ├── dev
        ├── test
        └── staging
```

## Variables and Environments

### Variable Group: Ticketing-Test-Config

| Variable | Default | Purpose |
|----------|---------|---------|
| API_BASE_URL | http://localhost:8000 | Ticketing API base URL |
| APP_URL | http://localhost:3000 | Web UI URL (for UI tests) |
| ROBOT_OUTPUT_DIR | results | Robot Framework output directory |
| PYTHON_VERSION | 3.12 | Python version for pipeline |

Override these per environment (dev/test/staging) by creating environment-specific variable groups or using pipeline variables.

### Environment-Specific Overrides

In an enterprise setup, you would:

1. Create variable groups per environment: `Ticketing-Test-Config-Dev`, `Ticketing-Test-Config-Test`, etc.
2. Use Azure DevOps Environments with approval gates for staging/production
3. Link variable groups to environments via pipeline YAML

## Authentication

Terraform requires:

- **AZDO_ORG_SERVICE_URL** – e.g. `https://dev.azure.com/your-org`
- **AZDO_PERSONAL_ACCESS_TOKEN** – PAT with:
  - Project and team: Read, write, & manage
  - Build: Read & execute
  - Variable groups: Read, create, & manage

Set via environment variables or `terraform.tfvars` (do not commit secrets).

## Extending for Enterprise

### 1. Remote State

```hcl
terraform {
  backend "azurerm" {
    resource_group_name  = "tfstate-rg"
    storage_account_name = "tfstate"
    container_name       = "azuredevops"
    key                  = "ticketing-test-automation.tfstate"
  }
}
```

### 2. Service Connections

For Azure Container Registry, Azure RM, or Docker Hub:

```hcl
resource "azuredevops_serviceendpoint_azurerm" "azure" {
  project_id            = azuredevops_project.ticketing.id
  service_endpoint_name = "AzureRM-Connection"
  credentials {
    service_principal_id  = var.azure_client_id
    service_principal_key = var.azure_client_secret
    subscription_id       = var.azure_subscription_id
    tenant_id             = var.azure_tenant_id
  }
}
```

### 3. GitHub Integration

To use Azure DevOps pipelines with a GitHub repository:

1. Create a GitHub service connection in Azure DevOps
2. Update the build definition `repository` block:
   - `repo_type = "GitHub"`
   - `repo_id = "org/repo"`
   - `service_connection_id = azuredevops_serviceendpoint_github.id`

### 4. Multiple Pipelines

Create additional `azuredevops_build_definition` resources for:

- Nightly regression
- Release validation
- Smoke tests on demand

## Limitations

- **Test Plans**: Azure Test Plans test cases and suites are not fully provisionable via Terraform. Use the UI, REST API, or import tools.
- **Repository content**: Terraform creates the project (and default repo); code is pushed via Git.
- **Pipeline YAML**: Stored in the repository; Terraform only creates the pipeline definition that references it.

## Files

| File | Purpose |
|------|---------|
| `main.tf` | Project, environments, variable group, build definition |
| `variables.tf` | Input variables |
| `outputs.tf` | Project ID, variable group ID, environment IDs |
| `providers.tf` | Azure DevOps provider configuration |
| `terraform.tfvars.example` | Example variable values |
