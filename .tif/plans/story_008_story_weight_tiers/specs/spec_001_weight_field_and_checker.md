---
story_id: story_008
spec_id: spec_001
title: Weight field and state-checker relaxation
completed: true
depends_on: []
contracts:
  provides:
    - tif.story.weight
  consumes: []
acceptance_checks:
  - id: check_001
    category: functional
    description: A spike-weight story omitting ADR.md and contracts.json is mechanically valid.
    steps:
      - "Step 1: Build a story whose only spec declares weight: spike, with no ADR.md and no contracts.json."
      - "Step 2: Run scripts/check-tif-state.sh on it."
      - "Step 3: Verify it reports state valid (no missing-ADR or missing-contracts errors)."
    passes: true
  - id: check_002
    category: functional
    description: A full-weight story still requires ADR.md and contracts.json.
    steps:
      - "Step 1: Build a story with default (no weight) specs and remove its ADR.md."
      - "Step 2: Run the checker."
      - "Step 3: Verify it fails with a missing ADR.md error."
    passes: true
---

# Weight Field And State-Checker Relaxation

## Implementation Notes

- `weight: spike | full` in spec frontmatter; the checker's frontmatter parser
  already captures arbitrary scalars, so no parser change is needed.
- In the per-story loop of `scripts/check-tif-state.sh`, read specs first, then
  compute `storyWeight = every spec weight === 'spike' ? 'spike' : 'full'`
  (empty/absent → 'full').
- Gate the `ADR.md` and `contracts.json` "missing" emits on `storyWeight !== 'spike'`.
  When present, both are validated exactly as before.

## Design Guidance

Default absent weight to `full` for backward compatibility. A story is spike
only when ALL its specs opt in — mixed stories stay full.

## TDD Unit-Test Plan

- `tests/tif-state/test-check-tif-state.sh`: a spike story without ADR/contracts
  passes; a full story without ADR fails (regression guard). Both added and green.

## Integration / E2E Expectation

`check-tif-state.sh` reports valid for a one-file spike story and still flags a
full story that drops its ADR.

## Owned Files

- `scripts/check-tif-state.sh`
- `tests/tif-state/test-check-tif-state.sh`

## Out Of Scope

- Weight defaulting/auto-proposal and skill guidance (spec_002).
