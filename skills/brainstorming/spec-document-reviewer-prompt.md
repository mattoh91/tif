# Planning Artifact Reviewer Prompt

Use this template after `.cutiepie/docs/PRD.md` and `.cutiepie/docs/feature_list.json` are written.

```yaml
description: "Review Cutiepie planning artifacts"
prompt: |
  Review the Cutiepie planning artifacts for completeness and consistency.

  Active artifacts:
  - .cutiepie/docs/PRD.md
  - .cutiepie/docs/feature_list.json
  - .cutiepie/docs/ARD.md
  - .cutiepie/docs/ARCHI.md
  - .cutiepie/docs/CONFIG.md
  - .cutiepie/docs/PLAN.md

  Check:
  - Every PRD user story maps to feature_list.json features.
  - feature_list.json has executable steps and all initial passes are false.
  - Tiny/backend-only waiver is explicit when comprehensive coverage is below the default threshold.
  - ARCHI.md dataflow supports the implementation phases.
  - ARD.md captures assumptions and caveats that affect decisions.
  - PLAN.md contains only workflow/phase progress, not individual feature pass/fail state.

  Return blocking issues first, then suggestions.
```
