# modules/budget/outputs.tf

output "budget_id" {
  value = azurerm_consumption_budget_subscription.budget.id
}