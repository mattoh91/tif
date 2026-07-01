---
story_id: story_008
spec_id: spec_002
title: Weight defaulting and skill guidance
completed: true
depends_on:
  - spec_001
contracts:
  provides: []
  consumes:
    - tif.story.weight
acceptance_checks:
  - id: check_001
    category: functional
    description: The spec frontmatter contract documents the weight field.
    steps:
      - "Step 1: Read skills/using-tif/SKILL.md."
      - "Step 2: Verify the Spec Frontmatter Contract shows weight: full | spike."
      - "Step 3: Verify a Story Weight section defines spike vs full and the spike relaxations."
    passes: true
  - id: check_002
    category: functional
    description: Planning skills instruct auto-inferring weight and emitting proportional artifacts.
    steps:
      - "Step 1: Read skills/using-tif and skills/story-planner."
      - "Step 2: Verify weight is inferred from project_mode + story shape and stated for one-line override."
      - "Step 3: Verify story-planner emits the lean shape (no ADR/contracts) at spike weight."
    passes: true
---

# Weight Defaulting And Skill Guidance

## Implementation Notes

- `skills/using-tif/SKILL.md`: add `weight` to the Spec Frontmatter Contract and
  a "Story Weight" section (spike vs full, where weight lives, the spike
  relaxations, and the auto-default rules).
- `skills/story-planner/SKILL.md`: right-size output to weight — at spike, one
  spec with `weight: spike`, no ADR, no contracts; hand off straight to build.
- Defaulting: `POC → spike`, `MVP → full`; nudge by story shape (single spec, no
  cross-spec contracts, no research triggers, or "prove/spike/validate" wording).
  State the inferred weight; override is one line; a trusted-automation setting
  may skip the confirm.

## Design Guidance

Keep weight a proposed default, not a silent decision — dropping ADR/contracts is
cheap to confirm and costly to get wrong. Ponytail (code minimalism) is a
separate layer and is not consulted for planning weight.

## TDD Unit-Test Plan

- Documentation/instruction change; no unit tests. Covered by the state-checker
  tests in spec_001 and by the acceptance checks above (skill-content assertions).

## Integration / E2E Expectation

A reader of `using-tif` learns the weight field, the tiers, and that weight is
auto-inferred; `story-planner` produces a lean spike when the story warrants it.

## Owned Files

- `skills/using-tif/SKILL.md`
- `skills/story-planner/SKILL.md`

## Out Of Scope

- The checker relaxation itself (spec_001).
- A dedicated `/spike` command or a settings toggle implementation (future).
