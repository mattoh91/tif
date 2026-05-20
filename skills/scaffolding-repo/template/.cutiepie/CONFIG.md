# Configuration

## Settings Class

Settings owner:

- Define the module/class/function that owns project configuration, for example `AppSettings`, `Settings`, `Config`, or equivalent.

Loading path:

- Define how settings are loaded: environment variables, config file, CLI flags, framework settings, or defaults.

Validation:

- Define how required values, ranges, enum values, and invalid combinations are validated.

## Hyperparameters and Tunables

| Setting | Owner | Type | Default | Allowed Range / Values | Source | Used By | Notes |
| --- | --- | --- | --- | --- | --- | --- | --- |
| `example_timeout_ms` | `Settings` | integer | `5000` | `>= 0` | env/config/default | component name | Replace with a real setting. |

## Rules

- All hyperparameters and tunable constants must live in the settings/config owner or be intentionally documented as local constants.
- Avoid scattering magic numbers, model names, thresholds, retry counts, token limits, temperature values, feature flags, timeouts, polling intervals, and batch sizes through implementation code.
- Update this file whenever a setting is added, removed, renamed, or changes default/range/meaning.
