# modules/ai-foundry/main.tf

data "azurerm_client_config" "current" {}

# Storage Account — required by AI Foundry hub
resource "azurerm_storage_account" "storage_account" {
  name                            = "st${replace(var.name, "-", "")}"
  resource_group_name             = var.resource_group_name
  location                        = var.location
  account_tier                    = "Standard"
  account_replication_type        = "LRS"
  https_traffic_only_enabled      = true
  min_tls_version                 = "TLS1_2"
  allow_nested_items_to_be_public = false
  tags                            = var.tags
}

# Key Vault — required by AI Foundry hub
resource "azurerm_key_vault" "key_vault" {
  name                       = "kv-${var.name}"
  resource_group_name        = var.resource_group_name
  location                   = var.location
  tenant_id                  = data.azurerm_client_config.current.tenant_id
  sku_name                   = "standard"
  purge_protection_enabled   = var.key_vault_purge_protection
  soft_delete_retention_days = var.key_vault_soft_delete_days
  tags                       = var.tags
}

# Key Vault access policy for the deploying user
resource "azurerm_key_vault_access_policy" "deployer" {
  key_vault_id = azurerm_key_vault.key_vault.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = data.azurerm_client_config.current.object_id

  key_permissions = [
    "Create",
    "Get",
    "Delete",
    "Purge",
    "GetRotationPolicy",
  ]
}

# AI Services — required by AI Foundry hub
resource "azurerm_ai_services" "ai_services" {
  name                = "ais-${var.name}"
  resource_group_name = var.resource_group_name
  location            = var.location
  sku_name            = "S0"
  tags                = var.tags
}

# AI Foundry Hub
resource "azurerm_ai_foundry" "hub" {
  name                  = "aih-${var.name}"
  location              = azurerm_ai_services.ai_services.location
  resource_group_name   = var.resource_group_name
  storage_account_id    = azurerm_storage_account.storage_account.id
  key_vault_id          = azurerm_key_vault.key_vault.id
  public_network_access = "Enabled"

  identity {
    type = "SystemAssigned"
  }

  tags = var.tags
}


# AI Foundry Project
resource "azurerm_ai_foundry_project" "project" {
  name               = "aip-${var.name}"
  location           = azurerm_ai_foundry.hub.location
  ai_services_hub_id = azurerm_ai_foundry.hub.id
  tags               = var.tags

  identity {
    type = "SystemAssigned"
  }
}

# deploys a model into AI Services so it's available in playground and via API
resource "azurerm_cognitive_deployment" "gpt4o" {
  name                 = "gpt-4o-mini"
  cognitive_account_id = azurerm_ai_services.ai_services.id

  model {
    format  = "OpenAI"
    name    = "gpt-4o-mini"
    version = "2024-07-18"
  }

  sku {
    name     = "Standard"
    capacity = 1 # 1k TPM — lowest possible
  }
}
