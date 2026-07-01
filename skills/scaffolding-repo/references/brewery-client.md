# Brewery GenAI Gateway Client

Unified interface for all LLM providers through the Heineken GenAI Gateway.

## Setup

Set the gateway API key in your shell or a gitignored `.env` file:

```bash
export GENAI_API_KEY="your-api-key-here"
```

Required Python dependencies:

```text
openai
anthropic
httpx
```

## Quick Start

```python
import os

from <project_name>.models.llmrouter import GenAIClient

client = GenAIClient(api_key=os.environ["GENAI_API_KEY"])

response = client.generate(
    "Summarise this document.",
    model="gpt-4.1",
    provider="openai",
)
print(response)
```

## Providers

| Provider | Example Models | Usage |
| --- | --- | --- |
| `openai` | `gpt-4.1`, `gpt-4.1-mini`, `gpt-4.1-nano` | General purpose, tool/function calling |
| `anthropic` | `claude-sonnet-4-6`, `claude-haiku-4-5` | Long context, analysis, coding |
| `google` | `gemini-2.5-flash`, `gemini-2.5-pro` | Multimodal and fast inference |
| `foundry` | `mistral-medium-2505`, `mistral-small-2503` | EU-hosted and cost-effective |

## Parameters

| Parameter | Type | Default | Description |
| --- | --- | --- | --- |
| `prompt` | `str` | required | User message |
| `model` | `str` | required | Provider-specific model name |
| `provider` | `str` | required | `openai`, `anthropic`, `google`, or `foundry` |
| `system` | `str | None` | `None` | System prompt where supported |
| `max_tokens` | `int` | `4096` | Max response tokens for Anthropic and Foundry |
| `temperature` | `float` | `1.0` | Sampling temperature for Anthropic and Foundry |

## Gateway URL

All requests go through:

```text
https://genai.heineken.com/models
```

Routes:

- OpenAI: `/openai/v1`
- Anthropic: `/anthropic`
- Google: `/google/<model>:generateContent`
- Foundry: `/foundry`
