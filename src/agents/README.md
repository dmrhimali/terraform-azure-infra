[REF](https://kind-sea-0cbd10e03.7.azurestaticapps.net/3_add-instructions.html)

[gut](https://github.com/GlobalAICommunity/agentcon-pizza-workshop)

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

Alternatively find endpoint at  ` az portal > go into azure subscription> resources > select ai foundry project resource (aifp-az-infra-sandbox-eus) > Resource Management > Endpoint > copy API Endpoint value to paste in e.env`

- Copy terraform output value for `gpt5_nano_deployment_name` and replace `"gpt-5-nano"` with that and save.

## Run basic agent (no system prompt)

```bash
cd src/agents

#install dependencies
uv sync 

#run agent
uv run .\agent.py
```

Now interact commandline:

### Output
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

## Run an agen with instructions/system prompt

```bash
cd src/agents

#install dependencies
uv sync 

#run agent
uv run .\agent_with_system_prompt.py
```

Now interact commandline:
```sh
 uv run .\agent_with_system_prompt.py
Agent created (id: pizza-agent:3, name: pizza-agent, version: 3)
Created conversation (id: conv_f05aacc761b7377000VW8rJ9HsXKIUl5BCmp3xo2WBs05D3PFe)
You: Hi
Assistant: Hi! How can I help with Microsoft Foundry today? Here are quick options. Tell me which one you want, and I’ll give you step-by-step instructions:

- Create a new project or dashboard
- Connect or refresh a data source
- Share or collaborate with teammates
- Customize widgets/visualizations
- Troubleshoot an issue (describe the error)
You: reate a new project or dashboard
Assistant: Great choice. Here are step-by-step paths for both options. Pick the one you want and I’ll tailor any details.

Option A: Create a new project
1) In Foundry, go to Projects (left navigation).
2) Click New Project (or + New Project).
3) Enter Project name and optional description.
4) Select a workspace/team and set visibility (private/public).
5) Add collaborators (optional).
6) Click Create. You’ll land in the new project.

Option B: Create a new dashboard
1) Open the target project (or go to Projects > select a project).
2) Click New Dashboard (or + New Dashboard).
3) Choose Blank or a Template, and name the dashboard.
4) Add widgets: click Add Widget, pick a visualization, and connect a data source.
5) Arrange layout and configure filters/interactions as needed.
6) Save. Optionally share or pin the dashboard to the project.

If you want, tell me your environment (web/Desktop) and whether you want a blank dashboard or a template, and I’ll tailor the steps precisely.
You: exit
Exiting the chat.
```

## Run an agen with instructions/system prompt
Run with detailed system prompt
```bash
cd src/agents

#install dependencies
uv sync 

#run agent
uv run .\agent_with_system_prompt_in_file.py
```

Now interact commandline:
```sh
\src\agents> uv run .\agent_with_system_prompt_in_file.py
Agent created (id: pizza-bot-agent:1, name: pizza-bot-agent, version: 1)
Created conversation (id: conv_9bcf3a2fa7262fb8009ObMna4o7AZnpAYzBtZHQ3WD6y19556B)
You: Hi
Assistant: Hi! Welcome to Contoso Pizza. I need your name and user ID to get started. If you don’t have an ID, just tell me your name. Which store would you like to order from? If you don’t say, I’ll use San Francisco, USA.

What would you like to do: view the menu, start an order, or check an existing order?
You: hi
Assistant: Hi there! Welcome to Contoso Pizza. Please tell me your name and, if you have one, your user ID. If you don’t have an ID, just share your name. Which store would you like to order from? If you don’t specify, I’ll use San Francisco, USA.

What would you like to do: view the menu, start an order, or check an existing order?
You: view the menu
Assistant: Sure, here are a few pizza options. Want more after this?

1) Classic Margherita - fresh tomatoes, mozzarella, basil
2) Pepperoni Feast - pepperoni, mozzarella, marinara
3) Veggie Supreme - peppers, onions, mushrooms, olives, mozzarella
4) BBQ Chicken - BBQ sauce, chicken, red onions, cheddar
5) Meat Lovers - pepperoni, sausage, ham, bacon, mozzarella

Would you like to hear more items or see sides and drinks as well?
You: what do you recommend for an asian food lover?
Assistant: Nice choice. We don’t have a dedicated Asian-style pizza on this menu, but the BBQ Chicken pizza often appeals to fans of Asian flavors because of its tangy sauce and toppings. It’s the closest fit here.

Would you like to start an order for BBQ Chicken, or should I show you more menu options (up to 5 at a time)?
You: exit
Exiting the chat.
(agent-helloworld) PS 
```

## Run an agen with RAG


```bash
cd src/agents

#install dependencies
uv sync 

#run agent
uv run .\agent_with_rag.py
```

Now interact commandline:
```sh
By default, the model only knows what it was trained on - it doesn't have access to your organization's private or domain-specific information.
To bridge this gap, we'll use Retrieval-Augmented Generation (RAG).

    - RAG lets the agent fetch relevant information from your own data before generating a response.
    - This ensures your agent's answers are accurate, up-to-date, and grounded in real information.
    - In Microsoft Foundry, we'll use the File Search feature to implement this.

In this chapter, you'll use a folder called ./documents that contains information about Contoso Pizza stores - such as locations, opening hours, and menus.

We'll upload these files to a vector store and connect that store to the agent using a File Search tool.
```