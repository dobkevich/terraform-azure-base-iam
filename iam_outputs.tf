output "admin_group_id" {
  description = "The Object ID of the AzureAdmins group."
  value       = azuread_group.admins.object_id
}

output "billing_group_id" {
  description = "The Object ID of the AzureBillingAdmins group."
  value       = azuread_group.billing_admins.object_id
}

output "standard_group_id" {
  description = "The Object ID of the AzureStandardUsers group."
  value       = azuread_group.standard_users.object_id
}

output "automation_sp_client_id" {
  description = "The Client ID of the automation service principal."
  value       = azuread_service_principal.automation_sp.client_id
}

output "subscription_id" {
  description = "The Subscription ID where roles are assigned."
  value       = data.azurerm_subscription.current.id
}
