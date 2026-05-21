# Configuration

## Environment Variables

| Variable | Owner | Type | Default | Required | Allowed Values / Range | Used By | Notes |
| --- | --- | --- | --- | --- | --- | --- | --- |
| `EXAMPLE_TIMEOUT_MS` | `Settings` | integer | `5000` | no | `>= 0` | component name | Replace with a real setting. |

## Rules

- Hyperparameters and tunables must be exposed through environment variables or an explicit settings/config owner.
- Document model names, temperatures, token limits, thresholds, retry counts, timeouts, polling intervals, batch sizes, feature flags, and similar values here.
- Update this file whenever an environment variable or tunable is added, removed, renamed, or changes default/range/meaning.
