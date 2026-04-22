variable "subscription_id" {
  description = "The subscription ID where the roles will be assigned."
  type        = string
}

variable "admin_username" {
  description = "The username (local part of UPN) for the admin user."
  type        = string
  default     = "azure_admin"
}

variable "standard_username" {
  description = "The username (local part of UPN) for the standard user."
  type        = string
  default     = "azure_standard"
}

variable "github_repository" {
  description = "The GitHub repository in the format 'owner/repo'."
  type        = string
  default     = "your-org/your-repo"
}

variable "initial_password" {
  description = "The initial password for the created users."
  type        = string
  sensitive   = true
  default     = "ChangeMe123!!!"
}

data "azurerm_subscription" "current" {}

# Get the primary domain of the Azure AD tenant to create valid UPNs
data "azuread_domains" "primary" {
  only_initial = true
}

locals {
  domain_name = data.azuread_domains.primary.domains[0].domain_name
}
