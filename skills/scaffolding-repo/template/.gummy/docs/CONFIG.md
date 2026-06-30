# Project Config

| Name | Owner | Type | Default | Required | Allowed Values | Used By | Notes |
| --- | --- | --- | --- | --- | --- | --- | --- |
| `GUMMY_ALLOW_RISKY_MEMORY` | Gummy memory review | boolean env flag | unset | no | `1` or unset | memory review | Allows promotion of high-risk memory candidates only when explicitly set. Leave unset by default. |
| `GENAI_API_KEY` | Heineken/Brewery projects | secret string | unset | only when Brewery client is enabled | non-empty | Brewery client | Heineken GenAI Gateway/Brewery API key. |
| `ATLASSIAN_MCP_CONFIG` | Heineken projects | path/string | unset | only when Atlassian MCP is enabled | host-specific | documentation workflow | Documents Jira/Confluence MCP setup. |

## Rules

- Add every environment variable, model name, retry count, timeout, threshold, feature flag, and tunable setting here.
- Story-specific decisions belong in `.gummy/plans/story_*/ADR.md`.
