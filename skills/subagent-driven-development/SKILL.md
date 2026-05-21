---
name: subagent-driven-development
description: Use when executing Cutiepie implementation work; compatibility entrypoint that now follows spec-driven development from feature_list.json.
---

# Subagent-Driven Development

This skill is the legacy-compatible name for `subagent-driven-spec-development`.

## Source Of Truth

- `.cutiepie/docs/feature_list.json` owns feature requirements, steps, references, implementation phases, dependencies, and `passes`.
- `.cutiepie/docs/PLAN.md` owns workflow progress only.
- Unit TDD is internal to implementer subagents and is not the visible progress unit.

## Workflow

1. Run `scripts/check-cutiepie-state.sh .`; stop on missing/invalid/blocked state.
2. Read `feature_list.json`, `PLAN.md`, `ARCHI.md`, `ARD.md`, and `CONFIG.md`.
3. Select the lowest `implementation_phase` with incomplete features.
4. Dispatch implementer subagents for parallel-safe features in that phase when available; otherwise execute serially.
5. Provide each implementer with the full feature JSON, relevant architecture excerpt, decisions/config excerpt, allowed files, input/output DTO shapes, neighbor contracts, and gate commands directly in the prompt.
6. Require implementers to:
   - write failing focused tests first
   - implement minimal code
   - run focused tests
   - run the prescribed feature steps from `feature_list.json`
   - self-review for completeness before reporting
   - report exact commands and outputs
7. Run spec compliance review before code quality review; repeat the implement/review loop until blocking issues are fixed or explicitly deferred by the user.
8. Change `passes` to `true` only for features whose prescribed steps pass.
9. Update `PLAN.md` only at phase/workflow level.
10. Commit coherent slices regularly.

## Stop Conditions

- A feature lacks executable steps.
- A later phase is being marked complete before earlier-phase features pass.
- `PLAN.md` duplicates feature pass/fail state.
- Required env vars or tunables are missing from `CONFIG.md`.
