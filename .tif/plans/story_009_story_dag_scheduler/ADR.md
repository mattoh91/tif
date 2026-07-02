# Story 009 ADR

## ADR-001: Story Dependencies Live In PRD Frontmatter

Status: Accepted

Problem:

- Story-level parallelism needs machine-readable inter-story dependencies. Today they exist only as prose in the PRD story table. They cannot live in ADR.md or contracts.json because spike weight makes both optional.

Decision:

- Add a `story_dag` block to `PRD.md` frontmatter: `story_dag: { story_002: [story_001], story_005: [story_001], ... }`. The PRD is the one always-present doc, so every story's deps have a stable, robust home.
- A story is **ready** when all of its dependency stories are complete (every spec `completed: true`) and it is not itself complete.
- The state checker validates the DAG: referenced stories exist, and the graph is acyclic (mirrors the existing spec-level `depends_on` checks, one level up).

Consequences:

- Story deps are visible next to the story table and parseable without depending on optional files.
- The existing spec-DAG primitive is reused conceptually at the story level.

## ADR-002: A DAG Scheduler Fans Ready Stories To Subagents; Weight Gates Auto-Advance

Status: Accepted

Problem:

- Sequential nudging (`/plato`, then `/aristotle`, per story, with manual gates) is the friction. But `/plato → /aristotle` within a story is a hard data dependency and cannot be parallelized; only *independent stories* can run concurrently.

Decision:

- A scheduler computes the ready set from the story DAG and dispatches each ready story to its own subagent (via `multi-agent-adapter`) that runs `/plato → /aristotle → verify` **internally sequential**. Multiple ready stories run **concurrently**.
- Weight gates the handoff: `spike` stories auto-advance through plato→aristotle→verify with no approval pause; `full` stories keep the "approve planning before implementation" gate.
- Dependents wait on the DAG, not on the user. The foundational spike (e.g. cartographer story_001) runs first because everything depends on it — scheduling, not a nudge, enforces order.
- The scheduler never pipelines a dependent story's design ahead of an unvalidated dependency; the DAG edge is the guard against "design before the bet is proven."

Consequences:

- Independent work parallelizes automatically; dependent work serializes automatically; the user approves the plan, not each step.
- Reuses tif's existing subagent execution (`subagent-driven-development`, `multi-agent-adapter`).

## ADR-003: The Visualizer Is Mermaid, Static-First

Status: Accepted

Problem:

- A live view of the DAG helps, but must stay thin — no heavy graph stack or mandatory server.

Decision:

- The scheduler writes `dag-status.json` (nodes, edges, per-story status). A generator renders it to a self-contained `docs/dag.html` with an embedded **Mermaid** flowchart, status-colored (done/running/ready/blocked), plus a terminal status board grouped by state.
- Optional `--serve`: serve `dag.html` on localhost with a poll-refresh of `dag-status.json`, reusing tif's brainstorm-server (localhost) pattern. Not required for the default static view.
- Mermaid (rejected for the presentation deck, ADR story_007) is correct here: a status DAG is a utility view where auto-layout is a feature, not a liability.

Consequences:

- Thin: no new heavy deps, renders on GitHub/IDEs, regenerates instantly on state change.
- Live watching is available (terminal board always; browser via optional `--serve`).
