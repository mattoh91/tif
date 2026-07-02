---
story_id: story_010
spec_id: spec_002
title: Content-hash contract staleness (not mtime)
completed: true
depends_on: []
contracts:
  provides: []
  consumes: []
acceptance_checks:
  - id: check_001
    category: functional
    description: Editing a non-contract spec field no longer reports contracts.json stale.
    steps:
      - "Step 1: Generate a valid story whose contracts.json carries spec_contracts_sha."
      - "Step 2: Flip a spec's passes flag (a non-contract field)."
      - "Step 3: Run check-tif-state.sh and verify no staleness warning."
    passes: true
  - id: check_002
    category: functional
    description: Changing a spec's provides/consumes does report staleness.
    steps:
      - "Step 1: From the same fixture, change a spec's provides or consumes list."
      - "Step 2: Run check-tif-state.sh."
      - "Step 3: Verify a staleness warning fires (hash mismatch)."
    passes: true
---

# Content-Hash Contract Staleness

## Implementation Notes

- Remove the mtime-based staleness check in `validateContracts`.
- Compute a SHA over each spec's `spec_id` + sorted `provides` + sorted `consumes`, concatenated in spec order.
- If `contracts.json` has `spec_contracts_sha` and it differs from the computed hash → emit a `warning` staleness message. If absent → no staleness warning.
- `contract-designer` writes `spec_contracts_sha` when it authors/updates contracts.json.

## TDD Unit-Test Plan

- Checker test: matching hash → no warning; flipping `passes` → hash unchanged → no warning (the fix); changing `provides`/`consumes` → hash mismatch → warning.

## Integration / E2E Expectation

Staleness reflects actual contract-declaration drift, not incidental file edits.

## Owned Files

- `scripts/check-tif-state.sh`
- `skills/contract-designer/SKILL.md`
- `tests/tif-state/test-check-tif-state.sh`

## Out Of Scope

- Other affordances.
