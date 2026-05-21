---
name: executing-plans
description: Use when executing Cutiepie implementation work inline from .cutiepie/docs/feature_list.json.
---

# Executing Plans

Inline fallback for hosts where subagents are unavailable. Prefer `subagent-driven-spec-development` when subagents are available.

## Step 0: Verify Cutiepie State

Run:

```bash
scripts/check-cutiepie-state.sh .
```

Stop on missing, invalid, or blocked state.

## Step 1: Load State

Read:

- `.cutiepie/docs/feature_list.json`
- `.cutiepie/docs/PLAN.md`
- `.cutiepie/docs/ARD.md`
- `.cutiepie/docs/ARCHI.md`
- `.cutiepie/docs/CONFIG.md`

Select the lowest `implementation_phase` with features whose `passes` is `false`.

## Step 2: Execute Feature Work

For each feature in the current phase:

1. Use internal TDD to build the required behavior.
2. Run focused tests.
3. Run component contract checks where boundaries changed.
4. Run the feature's prescribed steps from `feature_list.json`.
5. Set `passes: true` only if the prescribed steps pass.
6. Update `PLAN.md` only for workflow/phase progress.
7. Commit coherent slices.

## Step 3: Complete Development

After all target features pass, use `finishing-a-development-branch`.

## Stop Conditions

- Feature steps are ambiguous or non-executable.
- Required env vars/tunables are missing from `CONFIG.md`.
- A later phase is requested before earlier phases pass.
- Verification fails repeatedly.
