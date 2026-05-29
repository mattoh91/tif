---
name: build
description: Use when the user asks to build, deliver, implement, or continue the next Cutiepie story spec from .cutiepie/plans/story_*/specs/.
---

# Build

Use this as Cutiepie's delivery entrypoint.

## Workflow

1. Run `scripts/check-cutiepie-state.sh .`; stop on missing, invalid, blocked, or stale contract state.
2. Read `.cutiepie/docs/PRD.md`, `.cutiepie/docs/ARCHI.md`, `.cutiepie/docs/CONFIG.md`, and story folders under `.cutiepie/plans/`.
3. Select the next spec with `completed: false` whose dependencies are complete.
4. Use `multi-agent-adapter` to decide whether the host can dispatch workers or must run inline.
5. Provide each worker or inline task with the full spec, story `plan.md`, story `ADR.md`, `contracts.json`, allowed files, contract schemas, and gate commands.
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
