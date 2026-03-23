# environments/sandbox/outputs.tf

output "resource_group_name" {
  description = "Resource group name"
  value       = module.resource_group.name
}

output "ai_foundry_id" {
  description = "AI Foundry account ID"
  value       = module.ai_foundry.ai_foundry_id
}

output "ai_foundry_name" {
  description = "AI Foundry account name"
  value       = module.ai_foundry.ai_foundry_name
}

output "ai_foundry_endpoint" {
  description = "AI Foundry endpoint for API calls"
  value       = module.ai_foundry.ai_foundry_endpoint
}

output "ai_project_id" {
  description = "AI Foundry Project ID"
  value       = module.ai_foundry.project_id
}

output "ai_project_name" {
  description = "AI Foundry Project name"
  value       = module.ai_foundry.project_name
}

output "gpt5_nano_deployment_name" {
  description = "GPT-5-nano model deployment name"
  value       = module.ai_foundry.gpt5_nano_deployment_name
}
