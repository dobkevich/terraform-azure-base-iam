# Billing Management

resource "azuread_group" "billing_admins" {
  display_name     = "AzureBillingAdmins"
  security_enabled = true
  description      = "Group for billing and cost management"
}

# Assign Billing Reader role to the group
# Note: Use "Cost Management Contributor" for write access to budgets/exports
resource "azurerm_role_assignment" "billing_reader" {
  scope                = data.azurerm_subscription.current.id
  role_definition_name = "Billing Reader"
  principal_id         = azuread_group.billing_admins.object_id
}

# Add Human Admin to the BillingAdmins group 
resource "azuread_group_member" "admin_billing_membership" {
  group_object_id  = azuread_group.billing_admins.object_id
  member_object_id = azuread_user.azure_admin.object_id
}
