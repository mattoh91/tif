---
story_id: story_006
spec_id: spec_001
title: Artifact authority and redundancy slimming
completed: true
depends_on: []
contracts:
  provides:
    - tif.artifact_authority.matrix
  consumes: []
acceptance_checks:
  - id: check_001
    category: functional
    description: Active planning artifacts have non-overlapping ownership.
    steps:
      - "Step 1: Read PRD.md, ARCHI.md, CONFIG.md, story ADR.md, contracts.json, and specs."
      - "Step 2: Remove or relocate duplicated workflow/progress/decision content to the owning artifact."
      - "Step 3: Verify README and skills point to the same ownership matrix without adding another active planning surface."
    passes: true
  - id: check_002
    category: style
    description: Story completion state exists only in spec frontmatter.
    steps:
      - "Step 1: Inspect story folders for plan.md files or completion checklists that duplicate spec completion."
      - "Step 2: Replace duplicate completion prose with spec dependencies, ADR rationale, or contracts parallel groups."
      - "Step 3: Verify scripts/check-tif-state.sh . still passes."
    passes: true
---

# Artifact Authority And Redundancy Slimming

## Implementation Notes

Use the ownership matrix in the story ADR as the target. README and command docs may summarize the flow only if they point back to authoritative active artifacts.

## Research Findings

No external research is needed for this spec. This is an internal information-architecture cleanup.

## Design Guidance

Prefer deletion or short cross-references over moving the same prose into another file. If a detail is both a decision and an implementation instruction, keep the decision in ADR and the task-level instruction in the spec.

## TDD Unit-Test Plan

- Add or update static tests that scan active docs and story folders for banned duplicate completion surfaces.
- Keep `scripts/check-tif-state.sh .` as the mechanical state gate.

## Integration / E2E Expectation

Run the state checker and story-flow tests. A fresh session should be able to identify each artifact's authority without reading a second global plan.

## Owned Files

- `.tif/docs/PRD.md`
- `.tif/docs/ARCHI.md`
- `.tif/docs/CONFIG.md`
- `README.md`
- `skills/using-tif/SKILL.md`

## Out Of Scope

- Namespace rename.
- Memory implementation.
