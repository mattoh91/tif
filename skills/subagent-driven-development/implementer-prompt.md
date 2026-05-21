# Implementer Prompt Template

Use this template when dispatching a feature implementer.

```yaml
description: "Implement {FEATURE_ID}"
prompt: |
  You are implementing one Cutiepie feature from .cutiepie/docs/feature_list.json.

  Feature contract:
  {FEATURE_JSON}

  Relevant architecture:
  {ARCHI_EXCERPT}

  Relevant decisions/config:
  {ARD_AND_CONFIG_EXCERPT}

  Task boundary:
  - In scope: {IN_SCOPE}
  - Out of scope: {OUT_OF_SCOPE}

  Requirements:
  1. Use TDD internally: write failing focused tests, implement minimal code, and verify green.
  2. Run any component contract checks needed for touched boundaries.
  3. Run the feature's prescribed steps exactly as listed in feature_list.json.
  4. Do not set passes=true yourself unless you also provide exact command/output evidence.
  5. Commit coherent slices when requested by the parent agent.

  Report:
  - Status: DONE | DONE_WITH_CONCERNS | NEEDS_CONTEXT | BLOCKED
  - Files changed
  - Focused tests run and results
  - Feature steps run and results
  - Whether passes may be set to true
  - Any deviations or follow-ups
```
