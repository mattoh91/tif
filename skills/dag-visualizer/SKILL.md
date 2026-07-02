---
name: dag-visualizer
description: Use to see the story DAG and live scheduler status as a Mermaid graph or a terminal board. Thin, offline; pairs with dag-scheduler.
---

# DAG Visualizer

Render the story-level DAG (`scripts/dag/visualize.mjs`) from the graph +
`docs/dag-status.json` the scheduler writes.

- `node scripts/dag/visualize.mjs md .` → self-contained `docs/dag.md` with a
  status-colored Mermaid flowchart. Renders natively on GitHub / VS Code /
  Obsidian — no runtime, no network. Regenerate on each scheduler transition.
- `node scripts/dag/visualize.mjs board .` → terminal status board grouped by
  status (running / ready / blocked / failed / done) with dependency notes.
- `node scripts/dag/visualize.mjs watch .` → live in-terminal board that redraws on an interval as the scheduler updates `docs/dag-status.json` (Ctrl-C to stop).
- `node scripts/dag/visualize.mjs serve .` → optional localhost board that
  poll-refreshes; for watching a parallel run in a browser. No external deps.

Status classes: done, running, ready, blocked, failed. Spike stories carry a ◇
badge. Thin by design: Mermaid auto-layout, no graph framework, no mandatory server.
