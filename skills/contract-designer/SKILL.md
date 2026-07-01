---
name: contract-designer
description: Use after story specs are drafted to design contracts.json, align spec contract references, and validate cross-spec schemas before build.
---

# Contract Designer

This is a required post-spec planning gate. It is a skill, not a lifecycle hook, because contract design needs reasoning and may require spec edits.

## Inputs

Read the story folder:

- `ADR.md`
- `specs/spec_*.md`
- relevant `.tif/docs/PRD.md`, `ARCHI.md`, and `CONFIG.md`

## Workflow

1. Extract every spec's responsibilities, dependencies, provided data, consumed data, owned files, and integration boundaries.
2. Identify function signatures, DTOs, API payloads, database records, events, UI props/state, config requirements, and external-service payloads.
3. Write or update `contracts.json` with concrete contract IDs, provider spec, consumer specs, and schemas.
4. Patch spec frontmatter so `contracts.provides` and `contracts.consumes` exactly match `contracts.json`.
5. Confirm every consumed contract is provided by one spec or explicitly marked external.
6. Confirm there are no extra, missing, or ambiguous inputs/outputs.
7. Confirm dependency order and safe parallel groups.
8. Run `scripts/check-tif-state.sh .`.

## Contract Shape

Use this schema:

```json
{
  "schema_version": "tif.contracts.v1",
  "story_id": "story_001",
  "contracts": [
    {
      "id": "domain.entity.action",
      "provider": "spec_001",
      "consumers": ["spec_002"],
      "schema": {
        "type": "object",
        "required": ["id"],
        "properties": {
          "id": { "type": "string" }
        }
      }
    }
  ],
  "external_contracts": [],
  "parallel_groups": [["spec_001"], ["spec_002", "spec_003"]]
}
```

## Stop Conditions

- Specs are too vague to infer contracts.
- Multiple specs claim the same provider responsibility.
- A spec consumes data that no spec or external integration provides.
- Parallel groups would edit overlapping files or contracts.

Fix the specs first, then rerun contract design.
