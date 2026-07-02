---
name: using-tif
description: Core orientation for Tif's story-scoped SWE harness, active artifact locations, skill routing, and session gates.
---

# Using Tif

Tif turns a user's build request into PRD stories, story-local ADRs/specs/contracts, implementation, documentation, cleanup, and memory refresh.

## Active Artifacts

Active Tif state lives only in these locations:

```text
.tif/docs/
  PRD.md
  ARCHI.md
  CONFIG.md

.tif/plans/story_<nnn>_<slug>/
  ADR.md
  contracts.json
  specs/
    spec_<nnn>_<slug>.md
```

`PRD.md` owns human stories. Story `ADR.md` owns decisions and tradeoffs. Spec frontmatter owns dependencies, completion state, and acceptance checks. `contracts.json` owns cross-spec schemas and safe parallel groups. There is no separate global feature list, global implementation plan, or story `plan.md`.

## Required Trajectory

For a new idea:

1. Use `/socrates` or `brainstorming` to classify context, ask unresolved questions, and capture stories in `PRD.md`.
2. Use `/plato` to run required research, update architecture/ADR decisions, create story folders, draft specs, and design contracts.
3. Run `scripts/check-tif-state.sh .`.
4. Ask the user to approve planning before implementation.

For implementation:

1. Use `/aristotle` or `build`.
2. Build specs with `completed: false` in dependency order.
3. Use `multi-agent-adapter` for workers or inline fallback.
4. Use TDD for each spec.
5. Set acceptance check `passes: true` only after that check actually passes.
6. Set spec `completed: true` only after all acceptance checks pass.
7. Run `/finish`: `documentation`, then `cleanup`, then `update-state`, then `memory-review` for staged learning candidates.

## Spec Frontmatter Contract

Every spec must include:

```yaml
---
story_id: story_001
spec_id: spec_001
title: Short title
completed: false
weight: full        # full (default) | spike — omit for full
depends_on: []
contracts:
  provides: []
  consumes: []
acceptance_checks:
  - id: check_001
    category: functional
    description: High-level integration or e2e outcome.
    steps:
      - "Step 1: Do the setup."
      - "Step 2: Perform the action."
      - "Step 3: Verify the expected result."
    passes: false
---
```

Spec bodies should include implementation notes, research when tools/libraries/frameworks are involved, design patterns/algorithms/data structures where useful, TDD unit-test plan, and natural-language integration/e2e expectations.

## Story Weight (scope commensurate with effort)

Each story has a weight so planning ceremony matches the deliverable:

- `full` (default): ADR.md and contracts.json required; multi-spec, cross-spec contracts. Earns its keep when there are real tradeoffs, cross-component schemas, or parallel work.
- `spike`: a de-risking / prove-the-loop slice. Typically one spec. ADR.md and contracts.json are **optional, not forbidden** (`check-tif-state.sh` relaxes both). Goal is a learning, not a polished subsystem. Spike controls what's *required*, not what's *allowed* — if a spike makes a load-bearing decision (a POC often does), write the ADR for it; you're just no longer forced to when there's nothing to record.

Weight lives in spec frontmatter (`weight: spike`); a story is `spike` only when **every** spec opts in. Absent = `full` (backward compatible).

**Auto-default, don't hand-assign.** When a story is created (`/socrates`), infer weight and state it in one line; the user only intervenes to override:

- Default from `project_mode`: `POC → spike`, `MVP → full`.
- Nudge to `spike` when the story is a single spec with no cross-spec `provides`/`consumes` and no research triggers (external service, security, novel algorithm), or the story says "prove/spike/validate".
- Nudge to `full` when specs share contracts, security/data-loss is in scope, or research is required.

`/plato` emits proportional artifacts: at `spike`, one spec with inline acceptance checks and contracts omitted, plus an ADR only when a real decision surfaces; at `full`, the normal ADR + specs + contracts. `project_mode` sets the default weight but does not cap ceremony — a POC with a genuine tradeoff still gets its ADR. A trusted-automation setting may skip the one-line confirm.

## Heineken Projects

If project context is Heineken:

- bootstrap or document Brewery / GenAI Gateway client setup when relevant
- document `GENAI_API_KEY`
- set up or document Atlassian MCP
- prepare Confluence-ready GenAILab documentation
- ask for the target Confluence location and explicit approval before publishing

## Skill Routing

- New repo/session: `project-intake` (via `/onboard`, alias `/intake`)
- New idea/story: `brainstorming`, which routes through `prd-discovery`, `story-planner`, and `contract-designer`
- Requirements phase: `/socrates`, backed by `brainstorming` and `prd-discovery`
- Design phase: `/plato`, backed by `research-enrichment`, `solution-architect`, `story-planner`, and `contract-designer`
- Validation phase: `/aristotle`, backed by `build`, TDD, acceptance checks, and e2e tests when relevant
- Closeout phase: `/finish`, backed by `documentation`, `cleanup`, `update-state`, and `memory-review`
- Draft story folders directly: `story-planner`
- Align contracts after specs: `contract-designer`
- Build next work: `build`
- Parallel story scheduling: `dag-scheduler` (fan ready stories to subagents by the story DAG instead of stepping through /plato and /aristotle one at a time)
- Visualize the story DAG / live run: `dag-visualizer` (Mermaid `docs/dag.md` or a terminal board)
- Langfuse/agent observability work: `langfuse-agent-instrumentation` (project-agnostic instrumentation conventions; pairs with the official `langfuse` skill for generic CLI/docs)
- Inline execution compatibility: `executing-plans`
- Worker execution compatibility: `subagent-driven-development`
- Review feedback: `review`
- End-session docs: `documentation`
- End-session hygiene: `cleanup`
- Resume context: `preamble`
- Memory/state refresh: `update-state`
- Self-improvement review: `memory-review`

When a workflow dispatches subagents, reviewers, implementers, or parallel workers, use `multi-agent-adapter` to translate the same task packet for the current host.

## Stop Conditions

Stop before implementation when:

- `scripts/check-tif-state.sh .` fails.
- Specs exist but `contracts.json` is missing or stale.
- Consumed contracts are not provided or explicitly external.
- A spec lacks acceptance checks.
- A spec dependency is cyclic or incomplete.
- Heineken publishing would happen without user-approved target and approval.
