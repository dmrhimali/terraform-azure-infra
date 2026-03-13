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
#login to azure
az logout
    az cache purge
    az account clear
    az login --tenant <tenanat-id>
    az account show --query "{subscription:name, user:user.name, tenant:tenantId}" -o table

# make sure providers subscription id and tenanat id matches above az account equivalents 

# Preview changes
terraform plan
# plan only one resource:
terraform plan "-target=module.resource_group"


# Apply changes
terraform apply
# apply only one resource:
terraform apply "-target=module.resource_group"

# Destroy all resources
terraform destroy
```

> Always run `az account show` before any Terraform command to confirm you are on the correct account.

---

## Run model deployed with input using python.
Go to src directory and follow instructions in INSTRUCTIONS.md

## Notes

- `terraform.tfvars` is in `.gitignore` — never commit it
- State is stored remotely in Azure Blob Storage
- To add a new environment: copy `environments/sandbox` → update `terraform.tfvars` and the backend `key` in `providers.tf`

## Terraform shortcuts

```bash
# in powershell open notepad
notepad $PROFILE

#add following and save
function tf  { terraform $args }
function tfi { terraform init }
function tfp { terraform plan $args }
function tfa { terraform apply $args }
function tfd { terraform destroy $args }
function tfaa { terraform apply -auto-approve }
function tfv { terraform validate }
function tff { terraform fmt -recursive }
function tfo { terraform output }
function tfs { terraform state list }

# resource $PROFILE
 . $PROFILE
```

Usage:
```sh
tfp "-target=module.resource_group"
```

## Troubleshoot

### if `terraform plan` is hung with errors in registering providers :
This is a temporary Azure-side conflict — not a code problem. Just retry:

```powershell
tfp
```

Azure was processing multiple resource provider registrations at the same time and hit a conflict. It usually resolves on the next attempt.

If it keeps failing, add this to `providers.tf` to stop Terraform trying to auto-register providers:

**`environments/sandbox/providers.tf`** — add to provider block:
```hcl
provider "azurerm" {
  resource_provider_registrations = "none"   # ADDED: disable auto-registration
  
  features { ... }
  ...
}
```

Then manually register only what you need:
```powershell
az provider register --namespace Microsoft.MachineLearningServices
az provider register --namespace Microsoft.CognitiveServices
az provider register --namespace Microsoft.KeyVault
az provider register --namespace Microsoft.Storage
```

### Error: Error acquiring the state lock

```sh
 Error: Error acquiring the state lock
│
│ Error message: state blob is already locked
│ Lock Info:
│   ID:        e188c142-e279-00d9-8891-08b955e67567
│   Path:      tfstate/sandbox.terraform.tfstate
│   Operation: OperationTypePlan
│   Who:       AzureAD\RasanjaleeDissanayak@WDT-Rasanjalee
│   Version:   1.14.6
│   Created:   2026-03-12 13:40:42.6510015 +0000 UTC
│   Info:
│
```
The state is locked from a previous failed plan. Force unlock it:

```powershell
terraform force-unlock e188c142-e279-00d9-8891-08b955e67567
```

Type `yes` when prompted. Then retry:

```powershell
tfp
```

The lock was left behind when the earlier plan failed — this is safe to unlock since you're the only one using this state.

# after tf destroy cannot tf apply

```hcl
resource "azurerm_key_vault" "key_vault" {
  name                       = "kv-${var.name}"
  resource_group_name        = var.resource_group_name
  location                   = var.location
  tenant_id                  = data.azurerm_client_config.current.tenant_id
  sku_name                   = "standard"
  purge_protection_enabled   = var.key_vault_purge_protection
  soft_delete_retention_days = var.key_vault_soft_delete_days
  tags                       = var.tags
}
```

If you terraform destroy and recreate within 7 days, the Key Vault name `kv-az-infra-sandbox-eus` will conflict with the soft-deleted one. 

Fix:

```powershell
# After destroy, purge the soft-deleted vault before recreating
az keyvault purge --name kv-az-infra-sandbox-eus --location eastus
```

Then `tfa` will work cleanly.