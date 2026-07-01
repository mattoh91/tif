---
story_id: story_001
spec_id: spec_003
title: Contract design and build loop
completed: true
depends_on:
  - spec_001
contracts:
  provides: []
  consumes:
    - tif.story_state.layout
    - tif.spec_frontmatter.schema
    - tif.project_intake.profile
acceptance_checks:
  - id: check_001
    category: functional
    description: Contract design runs after specs and before build.
    steps:
      - "Step 1: Read the brainstorming, story-planner, contract-designer, and build skills."
      - "Step 2: Verify specs are drafted before contracts.json."
      - "Step 3: Verify /build stops when contracts are missing or invalid."
    passes: true
  - id: check_002
    category: functional
    description: Build scans incomplete specs rather than a global feature list.
    steps:
      - "Step 1: Read the build and subagent development skills."
      - "Step 2: Verify they select specs with completed: false."
      - "Step 3: Verify completed: true is only allowed after acceptance checks pass."
    passes: true
---

## Implementation Notes

Add `contract-designer` and repoint build/development skills to story specs. Keep `multi-agent-adapter` as the host dispatch layer.

## Design Pattern Guidance

Specs should suggest simple patterns, algorithms, and data structures only where they reduce ambiguity. Research-driven selection is required for ML algorithms, vector stores, databases, frameworks, modules, or tools.

## TDD Unit Tests

- Contract validator catches missing consumed contracts.
- Contract validator catches duplicate contract IDs or duplicate providers.
- Build skill references `completed: false` specs and `contracts.json`.

## Integration / E2E

Draft two dependent specs, run contract design, then run `/build`; verify the dependent spec is not selected before its dependency completes.
