---
name: story-planner
description: Use after PRD stories exist to create .cutiepie/plans/story_<nnn>_<slug>/ plan, ADR, draft specs, and then hand off to contract-designer.
---

# Story Planner

Create story-local planning folders from `PRD.md`.

## Output Shape

For each story:

```text
.cutiepie/plans/story_001_short_slug/
  plan.md
  ADR.md
  contracts.json
  specs/
    spec_001_component_or_flow.md
    spec_002_component_or_flow.md
```

Draft specs before designing contracts. `contracts.json` may start empty or placeholder only during drafting, but planning is not complete until `contract-designer` writes the real file and `scripts/check-cutiepie-state.sh .` passes.

## Plan Requirements

`plan.md` owns story workflow only:

- story goal
- spec sequence and safe parallel groups
- research tasks
- implementation order
- documentation and cleanup closeout

Do not duplicate spec completion state in prose. Spec completion lives in spec frontmatter.

## ADR Requirements

Each story folder has one `ADR.md`.

Record:

- library/module/tool choices
- algorithms and data structures
- design patterns
- contract-shape decisions
- important rejected options
- POC/MVP compromises

## Spec Frontmatter

Each spec must include:

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
    description: High-level e2e or integration outcome this spec must satisfy.
    steps:
      - "Step 1: Do the setup or navigation."
      - "Step 2: Perform the action."
      - "Step 3: Verify the expected result."
    passes: false
---
```

Specs should also include body sections for:

- implementation notes
- research findings when libraries, modules, tools, databases, vector stores, ML algorithms, or frameworks are involved
- design pattern, algorithm, and data-structure guidance
- TDD unit-test plan
- natural-language integration/e2e expectation, especially when both backend and frontend are involved
- owned files, allowed files, and out-of-scope files

## Parallelization

Write specs so subagents can work safely:

- explicit dependencies
- non-overlapping file scopes
- contract IDs for every data exchange
- input args and return schemas for functions
- API request/response schemas for endpoints
- event/message schemas for async boundaries
- UI state/props schemas where relevant

## Handoff

After specs are drafted, immediately use `contract-designer`. Planning is not complete until the story state checker passes.
