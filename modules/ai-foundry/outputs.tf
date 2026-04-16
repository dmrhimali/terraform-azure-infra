# modules/ai-foundry/outputs.tf

output "ai_foundry_id" {
  description = "AI Foundry account ID"
  value       = azurerm_cognitive_account.ai_foundry.id
}

output "ai_foundry_name" {
  description = "AI Foundry account name"
  value       = azurerm_cognitive_account.ai_foundry.name
}

output "ai_foundry_endpoint" {
  description = "AI Foundry endpoint for API calls"
  value       = azurerm_cognitive_account.ai_foundry.endpoint
}

output "project_id" {
  description = "AI Foundry Project ID"
  value       = azurerm_cognitive_account_project.project.id
}

output "project_name" {
  description = "AI Foundry Project name"
  value       = azurerm_cognitive_account_project.project.name
}

output "ai_foundry_primary_key" {
  description = "Primary key for API calls"
  value       = azurerm_cognitive_account.ai_foundry.primary_access_key
  sensitive   = true
}

output "gpt5_nano_deployment_name" {
  description = "GPT-5-nano model deployment name"
  value       = azurerm_cognitive_deployment.gpt5_nano.name
}

output "gpt5_mini_deployment_name" {
  description = "GPT-5-mini model deployment name"
  value       = azurerm_cognitive_deployment.gpt5_mini.name
}
