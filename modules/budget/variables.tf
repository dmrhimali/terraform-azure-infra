# modules/budget/variables.tf

variable "subscription_id" {
  type = string
}

variable "environment" {
  type = string
}

variable "amount" {
  type    = number
  default = 10
}

variable "alert_emails" {
  type = list(string)
}

variable "start_date" {
  description = "First of the month e.g. 2026-03-01T00:00:00Z"
  type        = string
}