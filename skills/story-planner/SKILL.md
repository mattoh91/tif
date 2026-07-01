---
name: story-planner
description: Use after PRD stories exist to create .tif/plans/story_<nnn>_<slug>/ ADR, draft specs, and then hand off to contract-designer.
---

# Story Planner

Create story-local planning folders from `PRD.md`.

## Output Shape

For each story:

```text
.tif/plans/story_001_short_slug/
  ADR.md
  contracts.json
  specs/
    spec_001_component_or_flow.md
    spec_002_component_or_flow.md
```

Draft specs before designing contracts. `contracts.json` may start empty or placeholder only during drafting, but planning is not complete until `contract-designer` writes the real file and `scripts/check-tif-state.sh .` passes.

**Right-size to the story's weight (see `using-tif` → Story Weight).** At `spike` weight, emit the lean shape: one spec with `weight: spike` in its frontmatter and inline acceptance checks, **no ADR.md, no contracts.json** (the state checker relaxes both) — hand off straight to build. The full output shape above applies at `full` weight, where ADR and cross-spec contracts earn their keep. Infer weight from `project_mode` + story shape and state it; do not force a spike through full ceremony.

## ADR Requirements

Each story folder has one `ADR.md`.

Record:

- story goal and scope
- implementation sequence when it is not obvious from spec dependencies
- library/module/tool choices
- algorithms and data structures
- design patterns
- contract-shape decisions
- research tasks and conclusions
- important rejected options
- POC/MVP compromises
- documentation and cleanup closeout notes

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
