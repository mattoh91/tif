---
name: using-cutiepie
description: Core orientation for Cutiepie's story-scoped SWE harness, active artifact locations, skill routing, and session gates.
---

# Using Cutiepie

Cutiepie turns a user's build request into PRD stories, story-local plans/specs/contracts, implementation, documentation, cleanup, and memory refresh.

## Active Artifacts

Active Cutiepie state lives only in these locations:

```text
.cutiepie/docs/
  PRD.md
  ARCHI.md
  CONFIG.md

.cutiepie/plans/story_<nnn>_<slug>/
  plan.md
  ADR.md
  contracts.json
  specs/
    spec_<nnn>_<slug>.md
```

`PRD.md` owns human stories. Story folders own implementation flow. Spec frontmatter owns completion state. `contracts.json` owns cross-spec schemas. There is no separate global feature list or global implementation plan.

## Required Trajectory

For a new idea:

1. Use `project-intake` to classify greenfield/brownfield and personal/Heineken context.
2. Use `prd-discovery` to capture stories in `PRD.md`.
3. Use `story-planner` to create story folders and draft specs.
4. Use `contract-designer` after specs exist.
5. Run `scripts/check-cutiepie-state.sh .`.
6. Ask the user to approve planning before implementation.

For implementation:

1. Use `build`.
2. Build specs with `completed: false` in dependency order.
3. Use `multi-agent-adapter` for workers or inline fallback.
4. Use TDD for each spec.
5. Set acceptance check `passes: true` only after that check actually passes.
6. Set spec `completed: true` only after all acceptance checks pass.
7. Run `documentation`, then `cleanup`, then `update-state`.

## Spec Frontmatter Contract

Every spec must include:

```yaml
---
story_id: story_001
spec_id: spec_001
title: Short title
completed: false
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

## Heineken Projects

If project context is Heineken:

- bootstrap or document Brewery / GenAI Gateway client setup when relevant
- document `GENAI_API_KEY`
- set up or document Atlassian MCP
- prepare Confluence-ready GenAILab documentation
- ask for the target Confluence location and explicit approval before publishing

## Skill Routing

- New repo/session: `project-intake`
- New idea/story: `brainstorming`, which routes through `prd-discovery`, `story-planner`, and `contract-designer`
- Draft story folders directly: `story-planner`
- Align contracts after specs: `contract-designer`
- Build next work: `build`
- Inline execution compatibility: `executing-plans`
- Worker execution compatibility: `subagent-driven-development`
- Review feedback: `review`
- End-session docs: `documentation`
- End-session hygiene: `cleanup`
- Resume context: `preamble`
- Memory/state refresh: `update-state`

When a workflow dispatches subagents, reviewers, implementers, or parallel workers, use `multi-agent-adapter` to translate the same task packet for the current host.

## Stop Conditions

Stop before implementation when:

- `scripts/check-cutiepie-state.sh .` fails.
- Specs exist but `contracts.json` is missing or stale.
- Consumed contracts are not provided or explicitly external.
- A spec lacks acceptance checks.
- A spec dependency is cyclic or incomplete.
- Heineken publishing would happen without user-approved target and approval.
