---
name: executing-plans
description: Compatibility entrypoint for inline execution of the next incomplete Tif story spec.
---

# Executing Plans

Run story specs inline when subagents are unavailable.

## Workflow

1. Run `scripts/check-tif-state.sh .`.
2. Read the next story folder under `.tif/plans/`.
3. Pick a spec with `completed: false` whose dependencies are complete.
4. Use its `contracts.json`, `ADR.md`, TDD plan, and acceptance checks as the task contract.
5. Implement with TDD.
6. Run focused tests and acceptance checks.
7. Update spec frontmatter only after checks pass.
8. Run documentation, cleanup, and update-state.
