---
story_id: story_009
spec_id: spec_001
title: Story-level dependency graph and validation
completed: true
depends_on: []
contracts:
  provides:
    - tif.story_dag.graph
  consumes: []
acceptance_checks:
  - id: check_001
    category: functional
    description: The story DAG is parsed from PRD frontmatter and exposed with per-story weight and completion.
    steps:
      - "Step 1: Author a PRD with a story_dag block declaring inter-story depends_on."
      - "Step 2: Build the graph model over the .tif plans."
      - "Step 3: Verify nodes carry story_id, weight, and complete (all specs completed), and edges match the declared deps."
    passes: true
  - id: check_002
    category: functional
    description: The state checker rejects a cyclic or dangling story DAG.
    steps:
      - "Step 1: Declare story_dag with a cycle (story_a depends on story_b and vice versa)."
      - "Step 2: Run scripts/check-tif-state.sh."
      - "Step 3: Verify it fails; repeat with a dependency on a non-existent story and verify it fails."
    passes: true
  - id: check_003
    category: functional
    description: The ready set is computed correctly from completion state.
    steps:
      - "Step 1: Mark a dependency story complete and its dependent incomplete."
      - "Step 2: Compute the ready set."
      - "Step 3: Verify the dependent is ready only once every dependency story is complete."
    passes: true
---

# Story-Level Dependency Graph And Validation

## Implementation Notes

- Add a `story_dag` block to `PRD.md` frontmatter: `story_id -> [dependency story_ids]`. Absent = no deps (backward compatible; existing PRDs still valid).
- Extend `scripts/check-tif-state.sh` to parse `story_dag`, validate referenced stories exist and the graph is acyclic (reuse the spec-level `validateAcyclic` approach one level up), and expose a graph model (`tif.story_dag.graph`): nodes (story_id, weight, complete) + edges.
- A story is `complete` when every spec is `completed: true`; `ready` when all dependency stories are complete and it is not itself complete.

## Design Guidance

Weight per story is derived from its specs (a story is spike iff all specs are spike), reusing story_008. Keep the DAG parse tolerant of absent `story_dag`.

## TDD Unit-Test Plan

- `tests/tif-state/test-check-tif-state.sh`: cyclic story_dag fails; dangling story ref fails; a valid DAG passes; ready-set helper returns the expected stories for a given completion state.

## Integration / E2E Expectation

Given a PRD with `story_dag`, the checker validates it and a graph model is available for the scheduler and visualizer.

## Owned Files

- `scripts/check-tif-state.sh`
- `tests/tif-state/test-check-tif-state.sh`
- `skills/using-tif/SKILL.md` (document story_dag)

## Out Of Scope

- Scheduling/dispatch (spec_002) and visualization (spec_003).
