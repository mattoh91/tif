---
story_id: story_010
spec_id: spec_003
title: Parked stories exempt from the specs requirement
completed: true
depends_on: []
contracts:
  provides: []
  consumes: []
acceptance_checks:
  - id: check_001
    category: functional
    description: A parked story with only an ADR passes the checker.
    steps:
      - "Step 1: Create a story folder with ADR.md and no specs directory; list it in PRD frontmatter parked_stories."
      - "Step 2: Run check-tif-state.sh."
      - "Step 3: Verify it passes (no missing-specs error for the parked story)."
    passes: true
  - id: check_002
    category: functional
    description: The same story fails when not parked.
    steps:
      - "Step 1: Remove it from parked_stories."
      - "Step 2: Run check-tif-state.sh."
      - "Step 3: Verify it fails with the missing-specs error."
    passes: true
---

# Parked Stories

## Implementation Notes

- Parse `parked_stories: [story_nnn]` from PRD frontmatter (add `parseParkedStories` to `scripts/dag/story-dag.mjs`, reusing its frontmatter reader).
- In the checker's per-story loop, if the story id is in `parked_stories`, skip the structural requirements (specs directory, spec files, ADR, contracts) — but still validate any files that DO exist (e.g. a present ADR must have Status/Decision).

## TDD Unit-Test Plan

- Unit: `parseParkedStories` reads the list; empty when absent.
- Checker: an ADR-only story listed as parked passes; not-parked fails (missing specs).

## Integration / E2E Expectation

Early/incremental planning has a blessed home; a designed-but-not-built story stays valid until its specs land.

## Owned Files

- `scripts/check-tif-state.sh`
- `scripts/dag/story-dag.mjs`
- `tests/tif-state/test-check-tif-state.sh`
- `skills/prd-discovery/SKILL.md` (document parked_stories)

## Out Of Scope

- Other affordances.
