# Azure DevOps Terraform Provider
# https://registry.terraform.io/providers/microsoft/azuredevops/latest/docs
#
# Authentication (set as environment variables or in a .tfvars):
#   AZDO_ORG_SERVICE_URL  - e.g. https://dev.azure.com/your-org
#   AZDO_PERSONAL_ACCESS_TOKEN - PAT with appropriate scopes

terraform {
  required_version = ">= 1.5.0"

  required_providers {
    azuredevops = {
      source  = "microsoft/azuredevops"
      version = "~> 1.0"
    }
  }

  # Uncomment for remote state (recommended for team use)
  # backend "azurerm" {
  #   resource_group_name  = "tfstate-rg"
  #   storage_account_name = "tfstate"
  #   container_name       = "azuredevops"
  #   key                  = "ticketing-test-automation.tfstate"
  # }
}

provider "azuredevops" {
  org_service_url       = var.org_service_url
  personal_access_token = var.personal_access_token
}
