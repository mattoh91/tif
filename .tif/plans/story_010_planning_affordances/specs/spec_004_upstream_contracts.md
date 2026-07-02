---
story_id: story_010
spec_id: spec_004
title: First-class cross-story / upstream contract references
completed: true
depends_on: []
contracts:
  provides:
    - tif.contracts.upstream_ref
  consumes: []
acceptance_checks:
  - id: check_001
    category: functional
    description: A validated upstream contract reference is accepted.
    steps:
      - "Step 1: story_B external_contracts declares {id, upstream: story_A/spec_00N}; story_A/spec_00N provides that id; PRD story_dag has story_B -> story_A."
      - "Step 2: A spec in story_B consumes that id."
      - "Step 3: Run check-tif-state.sh and verify it passes."
    passes: true
  - id: check_002
    category: functional
    description: An unvalidatable upstream reference fails (not silently ignored).
    steps:
      - "Step 1: Point the upstream at a story/spec that does not provide the id, OR omit the story_dag edge."
      - "Step 2: Run check-tif-state.sh."
      - "Step 3: Verify it fails with a clear message (missing provider or missing dependency edge)."
    passes: true
---

# Cross-Story / Upstream Contract References

## Implementation Notes

- Build a global index of provided contracts across ALL stories: `contractId -> {story, spec}` (first pass over every story's specs).
- Extend `external_contracts` entries to allow `upstream: "story_<nnn>/spec_<nnn>"`.
- Validate each upstream ref: the referenced story+spec exist, that spec `provides` the contract id, and the consuming story has a `story_dag` edge to the upstream story. On any failure, emit `invalid` (no more silent-ignore).
- A spec's `consumes` is satisfied if the id is provided in-story, marked external (informational), or resolved via a validated upstream ref.

## TDD Unit-Test Plan

- Checker: valid upstream ref + dag edge → passes; wrong provider → fails; missing dag edge → fails; consuming a validated upstream id → passes.

## Integration / E2E Expectation

story_002 can declare "my output satisfies story_001's frozen validator" and have it mechanically checked, closing the silent escape hatch.

## Owned Files

- `scripts/check-tif-state.sh`
- `scripts/dag/story-dag.mjs`
- `tests/tif-state/test-check-tif-state.sh`
- `skills/contract-designer/SKILL.md`

## Out Of Scope

- Other affordances.
