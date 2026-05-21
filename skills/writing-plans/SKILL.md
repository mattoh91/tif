---
name: writing-plans
description: Use after Cutiepie planning artifacts exist to create or update .cutiepie/docs/PLAN.md as the workflow checklist.
---

# Writing Plans

Compatibility skill for the new spec-driven harness. It now writes `.cutiepie/docs/PLAN.md`, not a feature-by-feature implementation prose plan.

## Required Inputs

Before writing `PLAN.md`, verify these exist:

- `.cutiepie/docs/PRD.md`
- `.cutiepie/docs/feature_list.json`
- `.cutiepie/docs/ARD.md`
- `.cutiepie/docs/ARCHI.md`
- `.cutiepie/docs/CONFIG.md`

If any are missing, use the relevant planning skill first: `prd-discovery`, `feature-list-builder`, `research-enrichment`, `solution-architect`, or `implementation-sequencer`.

## Ownership Boundary

- `PLAN.md` owns workflow stage progress and phase-level checklist state.
- `feature_list.json` owns feature specs, steps, references, implementation phases, and `passes`.
- Do not duplicate feature pass/fail state in `PLAN.md`.
- Do not put feature IDs in checked `PLAN.md` items.

## Workflow

1. Read the canonical docs.
2. Add checklist sections for Bootstrapping, Planning, Spec Review, Spec-Driven Development, Documentation, and Completion.
3. Add implementation phase checklist groups based on distinct `implementation_phase` values.
4. Refer to `feature_list.json` for feature checks instead of copying feature state.
5. Run `scripts/check-cutiepie-state.sh .`.

## Handoff

After `PLAN.md` is valid and the user approves the planning artifacts, use `subagent-driven-spec-development`.
