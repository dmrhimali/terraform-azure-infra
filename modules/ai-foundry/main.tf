# modules/ai-foundry/main.tf

# Modern AI Foundry resource (Microsoft.CognitiveServices/accounts)
resource "azurerm_cognitive_account" "ai_foundry" {
  name                       = "aif-${var.name}"
  resource_group_name        = var.resource_group_name
  location                   = var.location
  kind                       = "AIServices"
  sku_name                   = "S0"
  custom_subdomain_name      = "aif-${var.name}"
  project_management_enabled = true

  identity {
    type = "SystemAssigned"
  }

  tags = var.tags
}

# Deploy gpt-4o-mini model
resource "azurerm_cognitive_deployment" "gpt4o_mini" {
  name                 = "gpt-4o-mini"
  cognitive_account_id = azurerm_cognitive_account.ai_foundry.id

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

data "azurerm_client_config" "current" {}

# Grant deploying user "Azure AI Developer" on the Foundry account
resource "azurerm_role_assignment" "ai_developer" {
  scope                = azurerm_cognitive_account.ai_foundry.id
  role_definition_name = "Azure AI Developer"
  principal_id         = data.azurerm_client_config.current.object_id
}

# Modern AI Foundry Project (child of cognitive account)
resource "azurerm_cognitive_account_project" "project" {
  name                 = "aifp-${var.name}"
  cognitive_account_id = azurerm_cognitive_account.ai_foundry.id
  location             = var.location

  identity {
    type = "SystemAssigned"
  }

  tags = var.tags
}
