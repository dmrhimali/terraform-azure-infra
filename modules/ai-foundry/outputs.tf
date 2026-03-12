# modules/ai-foundry/outputs.tf

output "hub_id" {
  description = "AI Foundry Hub ID"
  value       = azurerm_ai_foundry.hub.id
}

output "hub_name" {
  description = "AI Foundry Hub name"
  value       = azurerm_ai_foundry.hub.name
}

output "project_id" {
  description = "AI Foundry Project ID"
  value       = azurerm_ai_foundry_project.project.id
}

output "project_name" {
  description = "AI Foundry Project name"
  value       = azurerm_ai_foundry_project.project.name
}

output "storage_account_name" {
  description = "Storage account name"
  value       = azurerm_storage_account.storage_account.name
}

output "key_vault_name" {
  description = "Key Vault name"
  value       = azurerm_key_vault.key_vault.name
}

output "ai_services_name" {
  description = "AI Services name"
  value       = azurerm_ai_services.ai_services.name
}

# endpoint and key needed to call the model via API
output "ai_services_endpoint" {
  description = "AI Services endpoint for API calls"
  value       = azurerm_ai_services.ai_services.endpoint
}

output "ai_services_primary_key" {
  description = "Primary key for API calls"
  value       = azurerm_ai_services.ai_services.primary_access_key
  sensitive   = true
}