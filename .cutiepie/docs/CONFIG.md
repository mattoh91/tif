# Cutiepie Configuration

## Environment Variables

| Variable | Owner | Type | Default | Required | Allowed Values / Range | Used By | Notes |
| --- | --- | --- | --- | --- | --- | --- | --- |
| `CUTIEPIE_HOOK_EVENT` | lifecycle hooks | string | unset | no | `CodexStop`, `SessionEnd`, `PreCompact`, `manual`, or unset | `hooks/update-state` | Labels session notes written by hook-triggered state refreshes. |
| `CUTIEPIE_CODEX_PLUGIN_FORK` | `scripts/sync-to-codex-plugin.sh` | string | `mattoh91/openai-codex-plugins` | no | GitHub repo slug | Codex plugin sync | Overrides destination fork. |
| `CUTIEPIE_CODEX_PLUGIN_DEST` | `scripts/sync-to-codex-plugin.sh` | string | `plugins/cutiepie` | no | repo-relative path | Codex plugin sync | Overrides destination plugin path. |

## Rules

- Do not add third-party runtime dependencies without explicit user approval.
- New model names, token limits, timeouts, polling intervals, retry counts, feature flags, or batch sizes must be documented here and owned by a config/settings module or script.
