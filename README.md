# terraform-azure-infra

Azure infrastructure managed with Terraform.

## Structure

```
terraform-azure-infra/
├── environments/
│   └── sandbox/
│       ├── providers.tf      # Provider + backend config
│       ├── backend.tf        # Remote state bootstrap instructions
│       ├── main.tf
│       ├── variables.tf
│       ├── outputs.tf
│       └── terraform.tfvars  # Your values — never commit this
└── modules/
    ├── resource-group/
    ├── networking/
    └── storage/
```

---

## Prerequisites

- [Terraform](https://developer.hashicorp.com/terraform/install) >= 1.5.0
- [Azure CLI](https://learn.microsoft.com/en-us/cli/azure/install-azure-cli)
- Logged into the correct Azure account

```powershell
az-work  # clean login to office tenant
az account show --query "{subscription:name, user:user.name, tenant:tenantId}" -o table
```

---

## First-time Setup

### 1. Bootstrap remote state storage

Run once before `terraform init`. Replace values with your own.

```powershell
$RG        = "rg-tfstate-sandbox"
$SA        = "stterraformstatesboxdmrh"  # pick your unique name , max 24 chars
$CONTAINER = "tfstate"
$LOCATION  = "eastus"

az group create --name $RG --location $LOCATION

az storage account create `
  --name $SA `
  --resource-group $RG `
  --location $LOCATION `
  --sku Standard_LRS `
  --kind StorageV2 `
  --https-only true `
  --min-tls-version TLS1_2 `
  --allow-blob-public-access false

az storage container create `
  --name $CONTAINER `
  --account-name $SA
```

Then update the `storage_account_name` in `providers.tf` with your `$SA` value.

### 2. Fill in your values

Edit `environments/sandbox/terraform.tfvars`:

```hcl
subscription_id = "<your-subscription-id>"
tenant_id       = "<your-tenant-id>"
project         = "<your-project-name>"
```

### 3. Initialise

```powershell
cd environments/sandbox
terraform init
```

---

## Usage

```powershell
# Preview changes
terraform plan

# Apply changes
terraform apply

# Destroy all resources
terraform destroy
```

> Always run `az account show` before any Terraform command to confirm you are on the correct account.

---

## Notes

- `terraform.tfvars` is in `.gitignore` — never commit it
- State is stored remotely in Azure Blob Storage
- To add a new environment: copy `environments/sandbox` → update `terraform.tfvars` and the backend `key` in `providers.tf`
