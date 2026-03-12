# environments/sandbox/variables.tf

variable "subscription_id" {
  description = "Azure Subscription ID"
  type        = string
}

variable "tenant_id" {
  description = "Azure Tenant ID"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "sandbox"

  validation {
    condition     = contains(["sandbox", "dev", "staging", "prod"], var.environment)
    error_message = "Must be one of: sandbox, dev, staging, prod."
  }
}

variable "location" {
  description = "Azure region"
  type        = string
  default     = "eastus"
}

variable "location_short" {
  description = "Short location code used in resource naming"
  type        = string
  default     = "eus"
}

variable "project" {
  description = "Project name used in resource naming"
  type        = string
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {}
}

variable "budget_amount" {
  type    = number
  default = 10
}

variable "budget_alert_emails" {
  type = list(string)
}

variable "budget_start_date" {
  type = string
}