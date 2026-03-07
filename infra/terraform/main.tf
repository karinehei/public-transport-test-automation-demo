# -----------------------------------------------------------------------------
# Azure DevOps Infrastructure - Terraform
# Public Transport Ticketing Test Automation Demo
#
# This Terraform configuration provisions Azure DevOps resources for:
# - Project and repository structure
# - Variable groups for test configuration
# - Environments (dev, test, staging)
# - Pipeline references (YAML pipelines are stored in repo)
#
# Note: YAML pipelines (azure-pipelines.yml) are version-controlled in the
# repository. Terraform can create a build definition that references them.
# Service connections may require manual setup or Azure credentials.
# -----------------------------------------------------------------------------

# -----------------------------------------------------------------------------
# Project
# -----------------------------------------------------------------------------
resource "azuredevops_project" "ticketing" {
  name               = var.project_name
  description        = var.project_description
  visibility         = "private"
  version_control   = "Git"
  work_item_template = "Agile"

  features = {
    "boards"       = "enabled"
    "repositories" = "enabled"
    "pipelines"    = "enabled"
    "testplans"    = "enabled"
    "artifacts"    = "enabled"
  }
}

# -----------------------------------------------------------------------------
# Environments (for deployment stages and approvals)
# Used by pipelines for test/staging deployment gates
# -----------------------------------------------------------------------------
resource "azuredevops_environment" "environments" {
  for_each   = toset(var.environment_names)
  project_id = azuredevops_project.ticketing.id
  name       = each.value
  description = "Environment for ${each.value} - ticketing test automation"
}

# -----------------------------------------------------------------------------
# Variable Group - Test Configuration
# Centralizes API URL, app URL, timeout, and other test parameters
# -----------------------------------------------------------------------------
resource "azuredevops_variable_group" "test_config" {
  project_id   = azuredevops_project.ticketing.id
  name         = var.variable_group_name
  description  = "Shared test configuration for Robot Framework API, UI, and E2E tests"
  allow_access = true

  variable {
    name  = "API_BASE_URL"
    value = "http://localhost:8000"
  }

  variable {
    name  = "APP_URL"
    value = "http://localhost:3000"
  }

  variable {
    name  = "ROBOT_OUTPUT_DIR"
    value = "results"
  }

  variable {
    name  = "PYTHON_VERSION"
    value = "3.12"
  }
}

# -----------------------------------------------------------------------------
# Default Repository (created automatically with project)
# -----------------------------------------------------------------------------
data "azuredevops_git_repository" "repo" {
  project_id = azuredevops_project.ticketing.id
  name       = var.project_name
}

# -----------------------------------------------------------------------------
# Build Pipeline (YAML)
# References the azure-pipelines.yml in the repository.
# The pipeline YAML is the source of truth for stages and jobs.
# For GitHub/external repos: use repo_type GitHub + service_connection_id
# -----------------------------------------------------------------------------
resource "azuredevops_build_definition" "ci_tests" {
  project_id = azuredevops_project.ticketing.id
  name       = "${var.naming_prefix}-ci-tests"
  path       = "\\"

  ci_trigger {
    use_yaml = true
  }

  repository {
    repo_type   = "TfsGit"
    repo_id     = data.azuredevops_git_repository.repo.id
    yml_path    = var.pipeline_yaml_path
    branch_name = "main"
  }

  variable_groups = [azuredevops_variable_group.test_config.id]
}

# -----------------------------------------------------------------------------
# Service Connection Placeholder (Documentation)
# -----------------------------------------------------------------------------
# Azure DevOps service connections (e.g. Azure Resource Manager, Docker Registry)
# often require interactive setup or Azure credentials. For this demo:
#
# - If using Azure Container Registry: Create service connection manually
#   or use azuredevops_serviceendpoint_azurerm
# - If using Docker Hub: Create service connection manually
# - For local/self-hosted agents: No service connection needed
#
# Example for Azure RM (uncomment and configure if needed):
# resource "azuredevops_serviceendpoint_azurerm" "azure" {
#   project_id            = azuredevops_project.ticketing.id
#   service_endpoint_name = "AzureRM-Connection"
#   description           = "Azure Resource Manager connection"
#   credentials {
#     service_principal_id     = var.azure_client_id
#     service_principal_key    = var.azure_client_secret
#     subscription_id         = var.azure_subscription_id
#     tenant_id               = var.azure_tenant_id
#   }
# }
