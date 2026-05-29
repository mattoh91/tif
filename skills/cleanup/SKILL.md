---
name: cleanup
description: Use at the end of a Cutiepie session after documentation to remove stale state, flag orphaned specs/contracts, run state validation, and prepare memory refresh.
---

# Cleanup

Run this after `documentation` and before `update-state`.

## Checks

1. Run `scripts/check-cutiepie-state.sh .`.
2. Check for story folders with no matching PRD story.
3. Check for specs with `completed: true` and failing acceptance checks.
4. Check for contracts not referenced by any spec.
5. Check for stale contracts when specs changed after `contracts.json`.
6. Check for code/test changes without relevant spec or ADR updates.
7. Remove generated temp files only when clearly safe.
8. Report stale or orphaned files instead of deleting user-authored work.

## State Updates

Update only what is true:

- Spec `completed: true` only after all acceptance checks pass.
- Acceptance check `passes: true` only after the described verification was run.
- Story `plan.md` workflow checkboxes only after the work happened.
- Story `ADR.md` when decisions changed.
- `CONFIG.md` when env vars, settings, timeouts, models, thresholds, or MCP setup changed.

## Output

Report:

- cleanup actions taken
- stale/orphaned state found
- validation result
- memory/update-state command to run next
