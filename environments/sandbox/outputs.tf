# environments/sandbox/outputs.tf

output "resource_group_name" {
  description = "Resource group name"
  value       = module.resource_group.name
}

output "ai_hub_id" {
  description = "AI Foundry Hub ID"
  value       = module.ai_foundry.hub_id
}

output "ai_hub_name" {
  description = "AI Foundry Hub name"
  value       = module.ai_foundry.hub_name
}

output "ai_project_id" {
  description = "AI Foundry Project ID"
  value       = module.ai_foundry.project_id
}

output "ai_project_name" {
  description = "AI Foundry Project name"
  value       = module.ai_foundry.project_name
}

output "storage_account_name" {
  description = "Storage account name"
  value       = module.ai_foundry.storage_account_name
}

output "key_vault_name" {
  description = "Key Vault name"
  value       = module.ai_foundry.key_vault_name
}
