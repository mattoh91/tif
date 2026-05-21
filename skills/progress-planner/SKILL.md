---
name: progress-planner
description: Use after planning artifacts exist to create or update .cutiepie/docs/PLAN.md as the human workflow checklist.
---

# Progress Planner

Create or update `.cutiepie/docs/PLAN.md`.

## Ownership

`PLAN.md` owns workflow stage progress only:

- bootstrapping
- planning
- spec review
- implementation phase checkpoints
- documentation
- completion

`feature_list.json` owns individual feature completion. Do not copy feature IDs into checked `PLAN.md` items and do not put `passes` state in `PLAN.md`.

## Workflow

1. Read `PRD.md`, `feature_list.json`, `ARD.md`, `ARCHI.md`, and `CONFIG.md`.
2. Write a checklist with phase-level items.
3. Add one implementation phase group per `implementation_phase` value in `feature_list.json`.
4. Make each phase item refer back to `feature_list.json` for feature checks.
5. Run `scripts/check-cutiepie-state.sh .`.
