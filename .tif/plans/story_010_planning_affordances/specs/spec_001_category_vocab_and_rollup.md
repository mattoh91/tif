---
story_id: story_010
spec_id: spec_001
title: Richer acceptance-check category vocabulary + completion rollup
completed: true
depends_on: []
contracts:
  provides: []
  consumes: []
acceptance_checks:
  - id: check_001
    category: functional
    description: The checker accepts integration/e2e/security categories and rejects unknown ones.
    steps:
      - "Step 1: Author specs using category integration, e2e, and security."
      - "Step 2: Run check-tif-state.sh."
      - "Step 3: Verify all pass; then set a category to a bogus value and verify it fails."
    passes: true
  - id: check_002
    category: functional
    description: The checker prints a completion rollup summarizing stories complete and specs incomplete.
    steps:
      - "Step 1: Run check-tif-state.sh on a project with a mix of complete and incomplete stories."
      - "Step 2: Verify a summary line reports total stories, complete stories, and incomplete specs."
    passes: true
---

# Category Vocabulary + Completion Rollup

## Implementation Notes

- In `validateSpec`, change the allowed set to `functional | integration | e2e | style | security`.
- Add a rollup line to the checker output (in the node block, before exit):
  `- [summary] N stories, C complete, S specs incomplete.` Keep the bash `[ok]` verdict.

## TDD Unit-Test Plan

- Extend `tests/tif-state/test-check-tif-state.sh`: a fixture spec with `category: e2e` passes; `category: bogus` fails; the summary line appears with correct counts.

## Integration / E2E Expectation

`check-tif-state.sh` accepts the four new categories and surfaces a completion rollup.

## Owned Files

- `scripts/check-tif-state.sh`
- `tests/tif-state/test-check-tif-state.sh`
- `skills/using-tif/SKILL.md` (document the vocabulary)

## Out Of Scope

- Other affordances (specs 002–005).
