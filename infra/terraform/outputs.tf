# -----------------------------------------------------------------------------
# Terraform Outputs
# -----------------------------------------------------------------------------

output "project_id" {
  description = "Azure DevOps project ID"
  value       = azuredevops_project.ticketing.id
}

output "project_name" {
  description = "Azure DevOps project name"
  value       = azuredevops_project.ticketing.name
}

output "variable_group_id" {
  description = "Variable group ID for pipeline reference"
  value       = azuredevops_variable_group.test_config.id
}

output "environment_ids" {
  description = "Map of environment names to IDs"
  value       = { for k, v in azuredevops_environment.environments : k => v.id }
}

output "pipeline_id" {
  description = "Build pipeline ID"
  value       = azuredevops_build_definition.ci_tests.id
}

output "project_url" {
  description = "URL to the Azure DevOps project"
  value       = "${var.org_service_url}/${azuredevops_project.ticketing.name}"
}
