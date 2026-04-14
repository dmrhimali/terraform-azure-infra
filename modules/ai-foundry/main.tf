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

# Deploy gpt-5-nano model
resource "azurerm_cognitive_deployment" "gpt5_nano" {
  name                 = "gpt-5-nano"
  cognitive_account_id = azurerm_cognitive_account.ai_foundry.id

  model {
    format  = "OpenAI"
    name    = "gpt-5-nano"
    version = "2025-08-07"
  }

  sku {
    name     = "GlobalStandard"
    capacity = 30 # 30k TPM # 30 requests per min. (lowest possible is 1, i.e. 1K TPM)
  }
}

data "azurerm_client_config" "current" {}

# Grant deploying user "Azure AI Developer" on the Foundry account
# Azure AI Developer gives you broad control — creating deployments, managing projects, reading keys, and calling the data plane. 
resource "azurerm_role_assignment" "ai_developer" {
  scope                = azurerm_cognitive_account.ai_foundry.id
  role_definition_name = "Azure AI Developer"
  principal_id         = data.azurerm_client_config.current.object_id
}

# Grant deploying user "Cognitive Services User" for Agents data-plane access
# Cognitive Services User is narrower — primarily reading keys/endpoints and calling inference APIs. - needed for runnig src/agent_helloworld/agent.py
resource "azurerm_role_assignment" "cognitive_services_user" {
  scope                = azurerm_cognitive_account.ai_foundry.id
  role_definition_name = "Cognitive Services User"
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
