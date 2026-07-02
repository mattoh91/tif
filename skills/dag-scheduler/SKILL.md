---
name: dag-scheduler
description: Use to drive multiple ready stories in parallel from the story-level DAG instead of stepping through /plato and /aristotle one story at a time. Fans ready stories to subagents; dependents wait on the DAG.
---

# DAG Scheduler

Schedule stories by dependency, not by manual nudging. Independent ready stories
run in parallel; dependents wait on the graph; the foundational spike runs first
because everything depends on it.

## Inputs

- Story DAG from `PRD.md` frontmatter `story_dag` (validated by `scripts/check-tif-state.sh`).
- Graph + status logic: `scripts/dag/story-dag.mjs` and `scripts/dag/scheduler.mjs`.

## Driver Loop

1. Build the graph and seed the `done` set from already-complete stories:
   `node scripts/dag/scheduler.mjs status .` (writes/echoes the initial
   `tif.story_dag.status`; persist it to `docs/dag-status.json`).
2. Compute the dispatchable set (`node scripts/dag/scheduler.mjs next .`, or
   `dispatchable(graph, state)`). These are stories whose dependency stories are
   all `done`.
3. For each dispatchable story, launch **one subagent** via `multi-agent-adapter`
   that runs the story end to end: `/plato` (design) → `/aristotle` (build via
   `subagent-driven-development` for its independent specs) → verify.
   - **Gate by weight** (`gateFor`): `spike` → auto-advance plato→aristotle→verify
     with no approval pause; `full` → stop for planning approval before build.
   - Run dispatchable stories **concurrently** — they are independent by construction.
4. On each story transition, update `docs/dag-status.json` and recompute. When a
   story reaches `done`, its dependents may become ready — dispatch them.
5. **Never dispatch a story whose dependencies are not all `done`.** A `failed`
   story leaves its dependents `blocked`; do not start their design or build.
   This is the guard against building on an unvalidated bet.
6. Stop when no story is `running` or `ready`.

## Rules

- The within-story order `/plato → /aristotle` is sequential (design→build data
  dependency); only *independent stories* run in parallel.
- Do not pipeline a dependent story's `/plato` ahead of an unvalidated dependency.
- Respect the "approve planning before implementation" gate for `full` stories.
- Surface progress with the visualizer (`dag-visualizer`).
