---
name: implementation-sequencer
description: Use after ARCHI.md exists to set implementation_phase values in feature_list.json from dataflow and dependency order.
---

# Implementation Sequencer

Assign or update `implementation_phase` in `.cutiepie/docs/feature_list.json`.

## Rules

- Earlier phases must provide dependencies required by later phases.
- Features in the same phase should be parallel-safe for subagents.
- Do not use phases to express priority alone; priority is a separate field.
- If a feature depends on another feature, it must be in a later phase unless the dependency is already implemented.

## Workflow

1. Read `feature_list.json` and `ARCHI.md`.
2. Build the dependency graph from feature dependencies and component dataflow.
3. Assign phase numbers.
4. Keep `passes` unchanged.
5. Run `scripts/check-cutiepie-state.sh .`.
6. Update `PLAN.md` phase checklist only at the phase level.
