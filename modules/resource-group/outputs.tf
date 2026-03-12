# modules/resource-group/outputs.tf

output "name" {
  description = "Resource group name"
  value       = azurerm_resource_group.resource_group.name
}

output "id" {
  description = "Resource group ID"
  value       = azurerm_resource_group.resource_group.id
}

output "location" {
  description = "Resource group location"
  value       = azurerm_resource_group.resource_group.location
}