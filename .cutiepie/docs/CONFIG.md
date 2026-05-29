# Cutiepie Config

| Name | Owner | Type | Default | Required | Allowed Values | Used By | Notes |
| --- | --- | --- | --- | --- | --- | --- | --- |
| `CUTIEPIE_HOOK_EVENT` | lifecycle hooks | string | unset | no | `CodexStop`, `SessionEnd`, `PreCompact`, `manual`, or unset | `hooks/update-state` | Labels session notes written by hook-triggered state refreshes. |
| `CUTIEPIE_CODEX_PLUGIN_FORK` | `scripts/sync-to-codex-plugin.sh` | string | `mattoh91/openai-codex-plugins` | no | GitHub repo slug | Codex plugin sync | Overrides destination fork. |
| `CUTIEPIE_CODEX_PLUGIN_DEST` | `scripts/sync-to-codex-plugin.sh` | string | `plugins/cutiepie` | no | repo-relative path | Codex plugin sync | Overrides destination plugin path. |
| `GENAI_API_KEY` | Heineken/Brewery scaffolded runtime | secret string | unset | only for Heineken/Brewery projects | non-empty | `skills/scaffolding-repo/references/brewery-client.py` | Heineken GenAI Gateway/Brewery API key. |
| `ATLASSIAN_MCP_CONFIG` | Heineken project setup | path/string | unset | only for Heineken projects using Atlassian | valid MCP config path or host-native setting | project-intake, documentation | Documents the Atlassian MCP setup used for Jira/Confluence access. |

## Rules

- Project mode is captured in `PRD.md` frontmatter as `project_mode: POC` or `project_mode: MVP`.
- Personal vs Heineken context is captured in `PRD.md` frontmatter as `project_context: personal` or `project_context: heineken`.
- Story-specific settings and tradeoffs belong in the story `ADR.md`.
- Do not publish Confluence documentation without explicit user approval and target page confirmation.
