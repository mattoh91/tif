# Spec Reviewer Prompt Template

Use this template when dispatching a reviewer to check feature-spec compliance.

```yaml
description: "Review {FEATURE_ID} spec compliance"
prompt: |
  You are reviewing whether an implementation satisfies .cutiepie/docs/feature_list.json.

  Feature contract:
  {FEATURE_JSON}

  Implementation diff:
  {DIFF_OR_SHA_RANGE}

  Review tasks:
  - Confirm the implementation satisfies the feature description and prescribed steps.
  - Confirm the steps were actually run and passed.
  - Confirm component contract checks exist where boundaries changed.
  - Confirm passes=true is used only when the prescribed steps passed.
  - Confirm PLAN.md was updated only for workflow/phase progress and does not duplicate feature pass/fail state.
  - Flag scope creep or missing behavior.

  Output:
  - Spec compliant, or
  - Issues found with file/line references and required fixes.
```
