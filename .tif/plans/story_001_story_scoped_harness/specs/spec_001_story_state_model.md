---
story_id: story_001
spec_id: spec_001
title: Story state model and validator
completed: true
depends_on: []
contracts:
  provides:
    - tif.story_state.layout
    - tif.spec_frontmatter.schema
  consumes: []
acceptance_checks:
  - id: check_001
    category: functional
    description: The state checker accepts a valid story folder with plan, ADR, contracts, and spec frontmatter.
    steps:
      - "Step 1: Create a fixture with .tif/docs/PRD.md, ARCHI.md, CONFIG.md, and .tif/plans/story_001_auth/."
      - "Step 2: Add ADR.md, contracts.json, and specs/spec_001_login.md."
      - "Step 3: Run scripts/check-tif-state.sh against the fixture and verify it passes."
    passes: true
  - id: check_002
    category: functional
    description: The state checker rejects completed specs whose acceptance checks have not all passed.
    steps:
      - "Step 1: Mark a fixture spec completed: true."
      - "Step 2: Leave one acceptance_checks entry with passes: false."
      - "Step 3: Run scripts/check-tif-state.sh and verify it fails."
    passes: true
---

## Implementation Notes

Rewrite `scripts/check-tif-state.sh` around story folders. The checker should validate required global docs, story folder shape, spec frontmatter, contract references, dependency cycles, and completion flags.

## TDD Unit Tests

- Valid story fixture passes.
- Missing `contracts.json` fails.
- Duplicate contract provider fails.
- Completed spec with failing acceptance check fails.
- Cyclic spec dependencies fail.

## Integration / E2E

Run the checker against the actual Tif repo and verify it reports mechanically valid story state.
