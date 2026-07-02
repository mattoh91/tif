---
story_id: story_009
spec_id: spec_002
title: DAG scheduler with weight-gated subagent fan-out
completed: true
depends_on:
  - spec_001
contracts:
  provides:
    - tif.story_dag.status
  consumes:
    - tif.story_dag.graph
acceptance_checks:
  - id: check_001
    category: functional
    description: The scheduler dispatches every ready story concurrently and serializes dependents.
    steps:
      - "Step 1: Build a DAG where story_001 gates story_002 and story_005, which are independent of each other."
      - "Step 2: Run the scheduler from a state where only story_001 is ready."
      - "Step 3: Verify story_001 runs first; on its completion story_002 and story_005 become ready and dispatch together; their dependents wait."
    passes: true
  - id: check_002
    category: functional
    description: Weight gates the plato-to-aristotle handoff.
    steps:
      - "Step 1: Schedule a spike story and a full story that are both ready."
      - "Step 2: Run the scheduler."
      - "Step 3: Verify the spike auto-advances plato->aristotle->verify without an approval pause, while the full story stops for approval before aristotle."
    passes: true
  - id: check_003
    category: functional
    description: The scheduler emits live status and never advances a dependent past an unvalidated dependency.
    steps:
      - "Step 1: Run the scheduler and force a dependency story's verify to fail."
      - "Step 2: Inspect dag-status.json."
      - "Step 3: Verify the failed story is 'failed', its dependents stay 'blocked', and no dependent design/build was started."
    passes: true
---

# DAG Scheduler With Weight-Gated Subagent Fan-Out

## Implementation Notes

- Consume `tif.story_dag.graph`; loop: compute ready set → dispatch each ready story to its own subagent via `multi-agent-adapter` → await → recompute.
- Each story subagent runs `/plato → /aristotle → verify` **internally sequential** (the design→build data dependency is real and preserved).
- Weight gate (story_008): `spike` → run the internal chain with no approval pause; `full` → pause for planning approval before `/aristotle`.
- Write `tif.story_dag.status` (`dag-status.json`) on every transition: per-story status (blocked/ready/running/done/failed) + current phase.
- A dependent is dispatched only when all its dependency stories reach `done` — a failed dependency leaves dependents `blocked` (guards against building on an unvalidated bet).

## Design Guidance

Reuse `subagent-driven-development` for the intra-story build fan-out (independent specs already parallelize via `parallel_groups`). The new layer is only the story-level ready-set loop.

## TDD Unit-Test Plan

- Pure ready-set/transition logic unit-tested with fixed DAGs + completion states (no live subagents): diamond DAG dispatches the fan correctly; failed node blocks dependents; weight decides the gate flag.

## Integration / E2E Expectation

From a fresh DAG, the scheduler drives foundational stories first, fans independent ready stories to concurrent subagents, and stops dependents behind unmet/failed deps — all without per-step user nudging.

## Owned Files

- `scripts/` (scheduler + status writer)
- `skills/` (scheduler skill wiring for `/plato`, `/aristotle`, `multi-agent-adapter`)
- `tests/` (scheduler logic tests + fixtures)

## Out Of Scope

- DAG parsing/validation (spec_001) and visualization (spec_003).
- Any change to the intra-story spec parallelism, which already exists.
