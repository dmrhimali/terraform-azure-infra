# VS Code for the Web - Azure AI Foundry

We've generated a simple development environment for you to play with sample code to create and run the agent that you built in the Azure AI Foundry playground.

The Azure AI Foundry extension provides tools to help you build, test, and deploy AI models and AI Applications directly from VS Code. It offers simplified operations for interacting with your models, agents, and threads without leaving your development environment. Click on the Azure AI Foundry Icon on the left to see more.

Follow the instructions below to get started!

## Open the terminal

Press ``Ctrl-` `` &nbsp; to open a terminal window.

## Run your model locally
install dependencies in requirements.txt in a virtual environment
```sh
cd src
uv python pin 3.12         
uv venv                  
uv pip install ansible-core~=2.17.0   
uv pip install ansible-core~=2.17.0
uv pip install python-dotenv

.\.venv\Scripts\activate.ps1 #activate venv
```
Update .env woth correct values. AZURE_OPENAI_API_KEY is in `https://ai.azure.com >  gpt-4o-mini (deployed model in TF) > Models+ Endpoints > Key


To run the model that you deployed in AI Foundry using terraform, and view the output in the terminal run the following command:

```bash
python run_model.py
```

output:
```sh
(src) PS C:\Users\RasanjaleeDissanayak\TestProjects\terraform-azure-infra\src> python run_model.py
{
  "id": "chatcmpl-DInRkqUZkIDqGLdffaceqVitT9KhO",
  "choices": [
    {
      "finish_reason": "stop",
      "index": 0,
      "logprobs": null,
      "message": {
        "content": "The Eiffel Tower, or \"La Tour Eiffel,\" is an iconic symbol of Paris and one of the most recognized structures in the world. Here are several reasons why it is so great:\n\n1. **Architectural Marvel**: Designed by Gustave Eiffel and completed in 1889 for the Exposition Universelle (World's Fair), the tower was initially criticized but has since been celebrated for its innovative iron lattice structure.\n\n2. **Breathtaking Views**: Standing at 1,083 feet (330 meters) tall, the Eiffel Tower offers panoramic views of Paris from its observation decks. On a clear day, you can see landmarks like the Seine River, Sacré-Cœur, and even the distant hills of Montmartre.\n\n3. **Cultural Significance**: The Eiffel Tower is a symbol of French culture and ingenuity. It represents the spirit of the Belle Époque and has become synonymous with romance and the allure of Paris.\n\n4. **Illuminations**: The tower is beautifully illuminated at night, with a sparkling light show that occurs every hour after sunset. The sight of the Eiffel Tower twinkling against the night sky is truly magical.\n\n5. **Historical Importance**: The tower has witnessed significant historical events and has been a part of many cultural moments, making it a living piece of history.\n\n6. **Accessibility**: The Eiffel Tower is open to visitors year-round, with multiple levels to explore. You can take the elevator or climb the stairs to enjoy different perspectives.\n\n7. **Surrounding Area**: The park around the tower, Champ de Mars, is a lovely area for picnics, strolls, and enjoying the view, making it a great spot for relaxation.\n\nWhether you're visiting for the views, the history, or the romantic atmosphere, the Eiffel Tower is a must-see attraction in Paris.",
        "refusal": null,
        "role": "assistant",
        "annotations": []
      },
      "content_filter_results": {
        "hate": {
          "filtered": false,
          "severity": "safe"
        },
        "protected_material_code": {
          "filtered": false,
          "detected": false
        },
        "protected_material_text": {
          "filtered": false,
          "detected": false
        },
        "self_harm": {
          "filtered": false,
          "severity": "safe"
        },
        "sexual": {
          "filtered": false,
          "severity": "safe"
        },
        "violence": {
          "filtered": false,
          "severity": "safe"
        }
      }
    }
  ],
  "created": 1773372348,
  "model": "gpt-4o-mini-2024-07-18",
  "object": "chat.completion",
  "system_fingerprint": "fp_eb37e061ec",
  "usage": {
    "completion_tokens": 374,
    "prompt_tokens": 217,
    "total_tokens": 591,
    "completion_tokens_details": {
      "accepted_prediction_tokens": 0,
      "audio_tokens": 0,
      "reasoning_tokens": 0,
      "rejected_prediction_tokens": 0
    },
    "prompt_tokens_details": {
      "audio_tokens": 0,
      "cached_tokens": 0
    }
  },
  "prompt_filter_results": [
    {
      "prompt_index": 0,
      "content_filter_results": {
        "hate": {
          "filtered": false,
          "severity": "safe"
        },
        "jailbreak": {
          "filtered": false,
          "detected": false
        },
        "self_harm": {
          "filtered": false,
          "severity": "safe"
        },
        "sexual": {
          "filtered": false,
          "severity": "safe"
        },
        "violence": {
          "filtered": false,
          "severity": "safe"
        }
      }
    }
  ]
}
```
YOU SEND (input):
├── system message  → "You are an AI assistant that helps people find information."
├── user message    → "I am going to Paris, what should I see?"
├── assistant msg   → "Paris, the capital of France..." (prior turn)
└── user message    → "What is so great about #1?"

MODEL RETURNS (output):
└── choices[0].message.content → the Eiffel Tower response

## Add, provision and deploy web app that uses the model

To add a web app that uses your model, run:

```bash
azd init -t https://github.com/Azure-Samples/get-started-with-ai-chat
```

You can provision and deploy this web app using:

```bash
azd up
```

To delete the web app and stop incurring any charges, run:

```bash
azd down
```



## Continuing on your local desktop

You can keep working locally on VS Code Desktop by clicking "Continue On Desktop..." at the bottom left of this screen. Be sure to take the .env file with you using these steps:

- Right-click the .env file
- Select "Download"
- Move the file from your Downloads folder to the local git repo directory
- For Windows, you will need to rename the file back to .env using right-click "Rename..."
