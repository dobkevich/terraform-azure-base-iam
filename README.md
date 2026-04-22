# Terraform Configuration for Azure IAM with OIDC Federation for GitHub Actions CI/CD

This project provides a comprehensive Terraform configuration for managing Identity and Access Management (IAM) in Microsoft Azure and Microsoft Entra ID (formerly Azure AD). It is designed to automate the creation of users, service principals, and role assignments, with a specific focus on secure CI/CD integration using Workload Identity Federation.

## Features

- **User Management**: Automates the creation of administrative users. Standard user creation is included as a template (commented out by default).
- **Role Assignments**:
    - **Admin**: Assigns "Owner" permissions for full infrastructure management.
    - **Billing**: Configures "Billing Reader" access for cost management.
    - **Standard**: Sets up "Reader" roles for restricted, view-only access.
- **Automation & Security**:
    - Creates a Service Principal for automated deployments with "Contributor" and "User Access Administrator" roles.
    - Implements **Workload Identity Federation (OIDC)**, allowing GitHub Actions to authenticate with Azure without the need for static client secrets.
- **Modular Configuration**: Clean separation of concerns between administration, billing, and CI/CD setup.

## Project Structure

- `terraform.tf`: Provider and backend configuration.
- `variables.tf`: Input variables for customization (subscription IDs, usernames, etc.).
- `iam_admin.tf`: Configuration for administrative users, groups, and service principals.
- `iam_billing.tf`: Configuration for billing-related roles and access.
- `iam_standard.tf`: Configuration for standard users and reader roles (user creation is optional).
- `iam_outputs.tf`: Standard Terraform outputs (Group IDs, Service Principal IDs).
- `iam_cicd.tf.template`: **Optional** configuration for GitHub CI/CD integration using OIDC.
- `cicd_github_action.yaml`: A sample GitHub Actions workflow file.
- `README_CICD`: A detailed technical guide for the OIDC setup.

## Usage

### 1. Prerequisites
- [Terraform](https://www.terraform.io/downloads.html) (>= 1.0)
- [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli)
- An active Azure Subscription and Entra ID (Azure AD) Tenant.

### 2. Configuration
Create a `terraform.tfvars` file (this file is ignored by Git) to provide your specific values:

```hcl
subscription_id   = "your-azure-subscription-id"
admin_username    = "admin.user"
standard_username = "standard.user"
github_repository = "your-org/your-repo" # Only needed if using CI/CD
initial_password  = "SecurePassword123!"
```

### 3. Deployment
Initialize and apply the Terraform configuration:

```bash
terraform init
terraform plan
terraform apply
```

### 4. GitHub CI/CD Setup (Optional)
This project includes a template for setting up Workload Identity Federation with GitHub. This allows your GitHub Actions to securely access your Azure resources without using passwords or secrets.

- **To use it**: Rename `iam_cicd.tf.template` to `iam_cicd.tf`.
- **Purpose**: It creates a Federated Identity Credential that trusts your specific GitHub repository.
- **Benefit**: No manual secret rotation; tokens are short-lived and issued only to your repository during a run.

Refer to the included `cicd_github_action.yaml` for an example of how to configure your GitHub workflow.

## Security Note
Always handle the `initial_password` and your `terraform.tfvars` file with care. The `.gitignore` included in this project is configured to prevent sensitive files from being committed.

## License
This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
