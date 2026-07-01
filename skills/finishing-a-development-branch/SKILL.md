---
name: finishing-a-development-branch
description: Use after a story spec or branch slice is implemented to verify, document, clean up, refresh state, and present integration options.
---

# Finishing A Development Branch

## Workflow

1. Run focused tests and affected spec acceptance checks.
2. Run `scripts/check-tif-state.sh .`.
3. Update spec acceptance flags and `completed` only when evidence passes.
4. Update story `ADR.md`, `contracts.json`, `ARCHI.md`, or `CONFIG.md` only when the work changed them.
5. Use `documentation`.
6. Use `cleanup`.
7. Use `update-state`.
8. Commit coherent changes when requested or when the workflow requires it.
9. Present merge/PR/continue options.

Never claim the story or spec is complete from unit tests alone.
