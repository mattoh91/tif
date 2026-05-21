---
name: subagent-driven-spec-development
description: Use when implementing Cutiepie features from feature_list.json by implementation_phase with internal TDD and feature-step pass verification.
---

# Subagent-Driven Spec Development

Implement by `implementation_phase` from `.cutiepie/docs/feature_list.json`.

## Contract

- `feature_list.json` is the implementation source of truth.
- `PLAN.md` is a workflow checklist only.
- TDD is internal to implementer subagents.
- A feature may change `passes` from `false` to `true` only after every prescribed feature step passes.

## Workflow

1. Run `scripts/check-cutiepie-state.sh .`; stop on blocked/invalid state.
2. Read `feature_list.json`, `PLAN.md`, `ARCHI.md`, `ARD.md`, and `CONFIG.md`.
3. Select the lowest implementation phase with any feature whose `passes` is `false`.
4. Dispatch parallel implementer subagents only for features in the same phase when their dependencies do not overlap.
5. Provide each implementer with the full feature JSON, relevant architecture excerpt, decisions/config excerpt, allowed files, input/output DTO shapes, neighbor contracts, and gate commands directly in the prompt.
6. Each implementer:
   - writes focused failing tests first
   - implements the minimal code
   - runs focused tests
   - runs the feature's prescribed steps
   - self-reviews for completeness before reporting
   - reports exact commands, outputs, and changed files
7. Review implementation against the feature spec before code quality; repeat the implement/review loop until blocking issues are fixed or explicitly deferred by the user.
8. Set `passes: true` only for features whose prescribed steps passed.
9. Commit regularly after coherent slices.
10. Update `PLAN.md` only for phase-level workflow progress.

## Stop Conditions

- Missing or invalid canonical artifacts.
- A feature lacks executable steps.
- Required env vars or tunables are missing from `CONFIG.md`.
- Architecture dependencies make same-phase work unsafe.
