---
name: build
description: Use when the user asks to build, deliver, implement, or continue the next Gummy story spec from .gummy/plans/story_*/specs/.
---

# Build

Use this as Gummy's delivery entrypoint.

## Workflow

1. Run `scripts/check-gummy-state.sh .`; stop on missing, invalid, blocked, or stale contract state.
2. Read `.gummy/docs/PRD.md`, `.gummy/docs/ARCHI.md`, `.gummy/docs/CONFIG.md`, and story folders under `.gummy/plans/`.
3. Select the next spec with `completed: false` whose dependencies are complete.
4. Use `multi-agent-adapter` to decide whether the host can dispatch workers or must run inline.
5. Provide each worker or inline task with the full spec, story `ADR.md`, `contracts.json`, allowed files, contract schemas, and gate commands.
6. Implement with TDD:
   - write focused failing tests
   - implement the smallest useful change
   - run focused tests
   - run the spec's acceptance checks
7. Set each acceptance check `passes: true` only after it actually passes.
8. Set spec `completed: true` only after all acceptance checks pass.
9. Run `documentation`, then `cleanup`, then `update-state`.

## Stop Conditions

- Story state checker fails.
- `contracts.json` is missing or stale.
- A spec lacks executable acceptance checks.
- Consumed/provided contracts do not align.
- Required config or MCP setup is missing.
