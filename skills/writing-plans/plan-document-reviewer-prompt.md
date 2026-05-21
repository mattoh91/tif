# PLAN Reviewer Prompt Template

Use this template when reviewing `.cutiepie/docs/PLAN.md`.

```yaml
description: "Review Cutiepie PLAN ownership"
prompt: |
  Review .cutiepie/docs/PLAN.md against the Cutiepie state contract.

  References:
  - .cutiepie/docs/feature_list.json
  - .cutiepie/docs/ARCHI.md
  - scripts/check-cutiepie-state.sh .

  Check:
  - PLAN.md is a workflow checklist, not an implementation spec.
  - PLAN.md does not duplicate feature IDs, feature steps, or passes state.
  - PLAN.md has phase-level checkpoints matching implementation_phase values.
  - Later phases are not marked complete before earlier phases pass.
  - PLAN.md points readers to feature_list.json for feature completion.

  Output:
  - Approved, or
  - Blocking issues with line references.
```
