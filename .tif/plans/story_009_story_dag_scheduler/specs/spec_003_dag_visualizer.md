---
story_id: story_009
spec_id: spec_003
title: Thin Mermaid DAG visualizer
completed: true
depends_on:
  - spec_002
contracts:
  provides: []
  consumes:
    - tif.story_dag.graph
    - tif.story_dag.status
acceptance_checks:
  - id: check_001
    category: functional
    description: A self-contained docs/dag.md renders the story DAG as a status-colored Mermaid flowchart.
    steps:
      - "Step 1: Provide a graph + dag-status.json with a mix of done/running/ready/blocked stories."
      - "Step 2: Generate docs/dag.md."
      - "Step 3: Verify it contains a mermaid flowchart with all stories, dependency edges, and per-status classDef coloring, and no external http(s) references (plain text, renders natively on GitHub/IDEs)."
    passes: true
  - id: check_002
    category: functional
    description: A terminal status board summarizes the DAG grouped by state.
    steps:
      - "Step 1: Run the visualizer in terminal mode against the same status."
      - "Step 2: Verify it prints stories grouped as blocked/ready/running/done/failed with their dependencies."
      - "Step 3: Verify it re-renders when dag-status.json changes."
    passes: true
  - id: check_003
    category: style
    description: Optional --serve exposes the DAG on localhost with poll-refresh.
    steps:
      - "Step 1: Run the visualizer with --serve."
      - "Step 2: Load the localhost URL."
      - "Step 3: Verify the page reflects dag-status.json and updates on a poll interval without a manual reload."
    passes: true
---

# Thin Mermaid DAG Visualizer

## Implementation Notes

- Read `tif.story_dag.graph` + `tif.story_dag.status`; emit a Mermaid `flowchart` (nodes = stories with weight badge, edges = deps) with `classDef` coloring per status (done/running/ready/blocked/failed).
- Static default: write a self-contained `docs/dag.md` (Mermaid code block; renders natively on GitHub/IDEs, no runtime or network).
- Terminal board: print stories grouped by status with dependency annotations; re-render on `dag-status.json` change.
- Optional `--serve`: serve `dag.html` on localhost, polling `dag-status.json` on an interval. Reuse the brainstorm-server localhost pattern; no websockets required.

## Design Guidance

Mermaid (not drawio) is correct here — a status DAG is a utility view where auto-layout is desirable and instant regeneration matters. Keep it thin: no graph framework, no mandatory server.

## Research Findings

Confirm the Mermaid embedding approach (inline runtime vs pre-render) that keeps `dag.html` self-contained and offline, at build time. Reuse story_007's self-contained-HTML technique.

## TDD Unit-Test Plan

- Given a fixture graph + status, the generated `dag.html` contains every story node, every dependency edge, and the correct status class; contains no `http(s)://` resource references.
- Terminal renderer groups a fixture status correctly.

## Integration / E2E Expectation

While the scheduler runs, `docs/dag.html` and the terminal board reflect live per-story status (blocked → ready → running → done), giving an at-a-glance view of the parallel run.

## Owned Files

- `scripts/` (dag visualizer generator + optional server)
- `tests/` (visualizer output tests + fixtures)

## Out Of Scope

- DAG model/validation (spec_001) and scheduling (spec_002).
- Real-time websocket streaming (poll-refresh is sufficient).
