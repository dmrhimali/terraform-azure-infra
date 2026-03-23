# CLAUDE.md — terraform-azure-infra

## Project Overview
Terraform-managed Azure AI Foundry infrastructure with Python scripts to interact with deployed models.

**Stack:** Terraform >= 1.5.0, Azure CLI, Python 3.12, uv, OpenAI SDK, azure-identity

## Azure Context
- Subscription: Azure subscription 1 (personal)
- Tenant: personal Gmail tenant
- Region: eastus
- Naming convention: `{resource-prefix}-{project}-{environment}-{location}` e.g. `rg-az-infra-sandbox-eus`
- State storage: `sttfstatesandbox001` in `rg-tfstate-sandbox`

## Project Structure
```
environments/sandbox/   # Terraform root module (providers, main, vars, outputs)
modules/
  ai-foundry/           # AI Foundry (CognitiveServices) + Project
  resource-group/       # Azure resource group wrapper
  budget/               # Monthly budget alerts
src/
  run_model.py                                    # Calls GPT-4o-mini via Azure OpenAI API
  run_reasoning_model_with_reasoning_effort.py    # Calls o4-mini with reasoning_effort
  requirements.txt                                # Python deps
  INSTRUCTIONS.md                                 # Setup guide
  .env.example                                    # Credential template (safe to read)
```

## Commands

### Azure Authorization (required before any Terraform command)
Remind user to run `az-home` to authorize into their Azure subscription and confirm auth is complete before proceeding. Verify with:
```bash
az account show
```

### Terraform (run from `environments/sandbox/`)
| Alias | Command |
|-------|---------|
| `tfp` | terraform plan |
| `tfa` | terraform apply |
| `tfd` | terraform destroy |
| `tff` | terraform fmt -recursive |

Always run `tfp` before `tfa`.

### Python (run from `src/`)
```bash
uv python pin 3.12
uv venv
uv pip install -r requirements.txt
.\.venv\Scripts\activate.ps1
python run_model.py
```

### PowerShell Note
Use `if ($?)` to chain commands — never `&&`.

## Code Standards

### Terraform
- Add file path comment at top of every `.tf` file
- Use meaningful resource instance names — NEVER `"this"`
- Use modules for each concern — never flat `main.tf`
- Each module must have: `main.tf`, `variables.tf` (with descriptions), `outputs.tf`
- NEVER hardcode `subscription_id` or `tenant_id` in any `.tf` file
- NEVER add `azuread` provider unless explicitly requested
- NEVER create `backend.tf` — backend config lives in `providers.tf`
- When showing a change, show diff only — do not regenerate entire files

### Python
- Use `python-dotenv` for env vars — never hardcode keys
- All secrets via `.env` — never committed

## File Permissions — CRITICAL

### NEVER read these files (no exceptions)
- `src/.env`
- `**/terraform.tfvars`
- Any `*.tfvars` file (only `*.tfvars.example` is allowed)

### Safe to read
- `src/.env.example`
- `*.tfvars.example`
- `requirements.txt`, `INSTRUCTIONS.md`, `README.md`

### Do not modify any file without explicit user permission

### Require explicit confirmation before running
- `tfa` / `terraform apply`
- `tfd` / `terraform destroy`
- `git push`
- Any destructive Azure CLI command

## Security Rules — NEVER VIOLATE
- NEVER hardcode `subscription_id` or `tenant_id` in `.tf` files
- NEVER commit `.env` or `terraform.tfvars`
- ALWAYS verify `az account show` before terraform commands
- ALWAYS run `tfp` before `tfa`

## Known Issues / Gotchas
- `gpt-5-nano` version must be `2025-08-07` in eastus
- `azurerm_cognitive_account_project` requires an `identity` block
- Budget `subscription_id` needs full path: `/subscriptions/{id}`
- `custom_subdomain_name` on cognitive account must be globally unique
