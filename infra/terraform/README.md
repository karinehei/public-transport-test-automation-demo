# Terraform - Azure DevOps Infrastructure

Terraform configuration for provisioning Azure DevOps resources for the Public Transport Ticketing Test Automation project.

## What Terraform Manages

| Resource | Managed | Notes |
|----------|---------|-------|
| Azure DevOps Project | ✅ | Project with Agile template, all features enabled |
| Environments | ✅ | dev, test, staging |
| Variable Groups | ✅ | Test config (API_BASE_URL, APP_URL, etc.) |
| Build Pipeline | ✅ | References `azure-pipelines.yml` in repo |
| YAML Pipeline | ❌ | Version-controlled in repo (source of truth) |
| Service Connections | ❌ | Documented; create manually or extend Terraform |
| Test Plans / Suites | ❌ | Use Azure Test Plans UI or REST API |

## Prerequisites

- [Terraform](https://www.terraform.io/downloads) >= 1.5
- Azure DevOps organization
- Personal Access Token (PAT) with:
  - Project and team: Read, write, & manage
  - Build: Read & execute
  - Variable groups: Read, create, & manage

## Quick Start

```bash
cd infra/terraform

# Copy example variables
cp terraform.tfvars.example terraform.tfvars

# Edit terraform.tfvars with your org URL and PAT
# Or set environment variables:
#   export AZDO_ORG_SERVICE_URL="https://dev.azure.com/your-org"
#   export AZDO_PERSONAL_ACCESS_TOKEN="your-pat"

terraform init
terraform plan
terraform apply
```

## Using with GitHub

This project may use GitHub for source control. To use Azure DevOps pipelines with a GitHub repo:

1. Create a GitHub service connection in Azure DevOps (Project Settings → Service connections)
2. Modify the `azuredevops_build_definition` repository block to use `repo_type = "GitHub"` and the service connection ID
3. Or: Use the YAML pipeline as-is; Azure DevOps can be configured to use an external repo via the pipeline UI

## Outputs

- `project_id` – Project ID
- `variable_group_id` – Variable group for pipelines
- `environment_ids` – Map of environment names to IDs
- `pipeline_id` – Build pipeline ID
- `project_url` – Link to the project

## Documentation

See [docs/azure-devops/terraform-setup.md](../../docs/azure-devops/terraform-setup.md) for detailed setup and extension guidance.
