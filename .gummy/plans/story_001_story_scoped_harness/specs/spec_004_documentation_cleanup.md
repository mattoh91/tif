---
story_id: story_001
spec_id: spec_004
title: Documentation and cleanup closeout
completed: true
depends_on:
  - spec_001
  - spec_002
contracts:
  provides:
    - gummy.session_closeout.report
  consumes:
    - gummy.project_intake.profile
acceptance_checks:
  - id: check_001
    category: functional
    description: End-session flow includes documentation before cleanup and memory refresh.
    steps:
      - "Step 1: Read documentation, cleanup, finishing, and update-state skills."
      - "Step 2: Verify documentation runs before cleanup."
      - "Step 3: Verify cleanup checks orphaned specs, stale contracts, and stale state."
    passes: true
  - id: check_002
    category: functional
    description: Heineken documentation prepares Confluence-ready GenAILab content and asks before publishing.
    steps:
      - "Step 1: Read the documentation skill."
      - "Step 2: Verify it asks for the Confluence target under GenAILab."
      - "Step 3: Verify it proposes readable HTML documentation with diagrams and story/research context before publish."
    passes: true
---

## Implementation Notes

Add `documentation` and `cleanup` skills. Heineken documentation should prepare local HTML first, ask for the target Confluence page, and publish only after approval.

## Diagram Guidance

Prefer a high-level layer/dataflow diagram for most projects. Add C4 L1/L2 when actors, external systems, or deployable containers need clarity. Add sequence diagrams for only the most important flows.

## TDD Unit Tests

- Static contract tests confirm documentation and cleanup are referenced by build/finish/update-state flow.
- Heineken-specific docs mention Confluence, GenAILab, approval, and target page.

## Integration / E2E

Finish a story slice and verify the final report includes docs updated, cleanup actions, state check output, and memory refresh.
