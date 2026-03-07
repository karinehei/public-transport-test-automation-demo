# -----------------------------------------------------------------------------
# Azure DevOps Terraform Variables
# Public Transport Ticketing Test Automation Demo
# -----------------------------------------------------------------------------

variable "org_service_url" {
  description = "Azure DevOps organization URL (e.g. https://dev.azure.com/your-org)"
  type        = string
}

variable "personal_access_token" {
  description = "Personal Access Token for Azure DevOps (use env var or secret)"
  type        = string
  sensitive   = true
}

variable "project_name" {
  description = "Azure DevOps project name"
  type        = string
  default     = "TicketingTestAutomation"
}

variable "project_description" {
  description = "Project description"
  type        = string
  default     = "Public transport ticketing system - test automation demo with Robot Framework, API/UI/E2E tests"
}

variable "environment_names" {
  description = "List of environment names for test/staging"
  type        = list(string)
  default     = ["dev", "test", "staging"]
}

variable "variable_group_name" {
  description = "Name of the shared variable group for test configuration"
  type        = string
  default     = "Ticketing-Test-Config"
}

variable "naming_prefix" {
  description = "Prefix for resource naming (e.g. project abbreviation)"
  type        = string
  default     = "tta"
}

variable "pipeline_yaml_path" {
  description = "Path to the pipeline YAML file in the repository"
  type        = string
  default     = "azure-pipelines.yml"
}

variable "repository_name" {
  description = "Repository name (for Azure Repos) or external repo reference"
  type        = string
  default     = "TicketingTestAutomation"
}
