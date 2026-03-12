# modules/ai-foundry/variables.tf

variable "name" {
  description = "Base name used for all AI Foundry resources"
  type        = string
}

variable "resource_group_name" {
  description = "Resource group to deploy into"
  type        = string
}

variable "location" {
  description = "Azure region"
  type        = string
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {}
}

variable "key_vault_purge_protection" {
  description = "Enable purge protection on Key Vault. Set false for sandbox to allow destroy/recreate. Set true for prod."
  type        = bool
  default     = false
}

variable "key_vault_soft_delete_days" {
  description = "Soft delete retention days for Key Vault (7-90)"
  type        = number
  default     = 7
}
