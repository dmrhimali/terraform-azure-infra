# environments/sandbox/main.tf

locals {
  name_prefix = "${var.project}-${var.environment}-${var.location_short}"

  common_tags = merge(
    {
      Environment = var.environment
      Project     = var.project
      ManagedBy   = "terraform"
    },
    var.tags
  )
}

module "resource_group" {
  source = "../../modules/resource-group"

  name     = "rg-${local.name_prefix}"
  location = var.location
  tags     = local.common_tags
}

module "ai_foundry" {
  source = "../../modules/ai-foundry"

  name                = local.name_prefix
  resource_group_name = module.resource_group.name
  location            = var.location
  tags                = local.common_tags
}

module "budget" {
  source          = "../../modules/budget"
  subscription_id = var.subscription_id
  environment     = var.environment
  amount          = var.budget_amount
  alert_emails    = var.budget_alert_emails
  start_date      = var.budget_start_date
}