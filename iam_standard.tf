# Standard User Management

resource "azuread_group" "standard_users" {
  display_name     = "AzureStandardUsers"
  security_enabled = true
  description      = "Group for standard subscription viewers"
}

# Assign Reader role to the StandardUsers group
resource "azurerm_role_assignment" "standard_reader" {
  scope                = data.azurerm_subscription.current.id
  role_definition_name = "Reader"
  principal_id         = azuread_group.standard_users.object_id
}

## Create the Azure Standard user
#resource "azuread_user" "azure_standard" {
#  user_principal_name   = "${var.standard_username}@${local.domain_name}"
#  display_name          = "Azure Standard User (${var.standard_username})"
#  password              = var.initial_password
#  force_password_change = true
#
#  mail_nickname = var.standard_username
#}

## Member for Standard Users Group
#resource "azuread_group_member" "standard_membership" {
#  group_object_id  = azuread_group.standard_users.object_id
#  member_object_id = azuread_user.azure_standard.object_id
#}
