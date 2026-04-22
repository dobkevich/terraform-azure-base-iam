# Create the Azure Admin user
resource "azuread_user" "azure_admin" {
  user_principal_name   = "${var.admin_username}@${local.domain_name}"
  display_name          = "Azure Administrator (${var.admin_username})"
  password              = var.initial_password
  force_password_change = true

  # Azure users must have a Mail Nickname
  mail_nickname = var.admin_username
}

# 1. Human Admin Group
resource "azuread_group" "admins" {
  display_name     = "AzureAdmins"
  security_enabled = true
  description      = "Group for full subscription administrators"
}

# Member for Admin Group
resource "azuread_group_member" "admin_membership" {
  group_object_id  = azuread_group.admins.object_id
  member_object_id = azuread_user.azure_admin.object_id
}

# Assign Owner role to the Admins group
resource "azurerm_role_assignment" "admin_owner" {
  scope                = data.azurerm_subscription.current.id
  role_definition_name = "Owner"
  principal_id         = azuread_group.admins.object_id
}

# 2. Service Principal for programmatic access
# Analog to AWS IAM Access Key and GCP Service Account
resource "azuread_application" "automation_app" {
  display_name = "AutomationServicePrincipal"
}

resource "azuread_service_principal" "automation_sp" {
  client_id = azuread_application.automation_app.client_id
}

# Assign Contributor and User Access Administrator role to the Service Principal
# This allows it to manage resources AND permissions
# (similar to Owner, but often separated for automation)
resource "azurerm_role_assignment" "sp_contributor" {
  scope                = data.azurerm_subscription.current.id
  role_definition_name = "Contributor"
  principal_id         = azuread_service_principal.automation_sp.object_id
}

resource "azurerm_role_assignment" "sp_iam_admin" {
  scope                = data.azurerm_subscription.current.id
  role_definition_name = "User Access Administrator"
  principal_id         = azuread_service_principal.automation_sp.object_id
}
