## setup

```bash
uv sync
```

## Run infrastructure for azure AI Foundry
- Clone locally my project `https://github.com/dmrhimali/terraform-azure-infra`

- Login to azure command line
```bash
function az-work {
    az logout
    az cache purge
    az account clear
    az login --tenant <REPLACE-WITH-YOUR-TENANT-ID>
    az account show --query "{subscription:name, user:user.name, tenant:tenantId}" -o table
}
```

Apply resources
```bash
terraform apply
# keep a note of outputs to be added to .env
```

## Create .env with terraform output above

- Create .env with .env.example
```bash
cp .env.example .env
```

- Copy terraform output value for  `ai_foundry_endpoint` and replace `"https://<your-foundry-resource>.services.ai.azure.com/api/projects/<your-project-name>"` in .env

- Copy terraform output value for `gpt5_nano_deployment_name` and replace `"gpt-5-nano"` with that and save.

###

```bash
cd src/agent_helloworld

#install dependencies
uv sync 

#run agent
uv run .\agent.py
```

Now interact commandline:

## Output
```bash
uv run .\agent.py
warning: `VIRTUAL_ENV=C:\Users\RasanjaleeDissanayak\TestProjects\terraform-azure-infra\src\.venv` does not match the project environment path `.venv` and will be ignored; use `--active` to target the active environment instead
Agent created (id: pizza-agent:1, name: pizza-agent, version: 1)
Created conversation (id: conv_a4e3c7550dd25c0c00EgTP80iMG0RVkmfVV4pU8okIXO2UiiAM)
You: Hi
Assistant: Hello! How can I assist you today?
You: I want to order pizza
Assistant: Great choice! What kind of pizza are you thinking about? Do you have a specific style or toppings in mind?
You: 3 meat pizza
Assistant: A three-meat pizza sounds delicious! Typically, that would include toppings like pepperoni, sausage, and bacon. Would you like to add any other toppings, or do you prefer it just as is? Also, do you have a preferred crust type (thin, thick, stuffed)?
You: thick 
Assistant: Awesome choice! A thick crust with pepperoni, sausage, and bacon will be hearty and delicious. Do you want to add any sides or drinks to your order, like dipping sauces, salads, or beverages?
You: none
Assistant: Got it! Just a thick-crust three-meat pizza. If you're ordering online or calling a local pizzeria, just mention that. Enjoy your pizza! If you need anything else, let me know.
You: exit
Exiting the chat.
(src) PS C:\Users\RasanjaleeDissanayak\TestProjects\terraform-azure-infra\src\agent_helloworld> 
```