---
story_id: story_006
spec_id: spec_004
title: Aristotle empirical validation gate
completed: true
depends_on:
  - spec_002
  - spec_003
contracts:
  provides:
    - gummy.validation.gate_schema
  consumes:
    - gummy.trinity.workflow
    - gummy.research.evidence_record
acceptance_checks:
  - id: check_001
    category: functional
    description: Implementation requires failing tests before production changes where practical.
    steps:
      - "Step 1: Select the next dependency-ready spec and identify its unit/component test target."
      - "Step 2: Verify /aristotle writes or updates a failing test before production changes unless an explicit exception is documented."
      - "Step 3: Verify acceptance check passes are updated only after the relevant commands pass."
    passes: true
  - id: check_002
    category: functional
    description: UI-facing work includes Playwright or equivalent e2e evidence.
    steps:
      - "Step 1: Select a UI-facing story spec."
      - "Step 2: Verify /aristotle defines an e2e route, action, and assertion plan."
      - "Step 3: Verify final completion records the e2e command and result before completed is true."
    passes: true
---

# Aristotle Empirical Validation Gate

## Implementation Notes

Make `/aristotle` the canonical validation phase over the existing `build` behavior. It should:

1. Run `scripts/check-gummy-state.sh .`.
2. Select the next dependency-ready incomplete spec.
3. Write or update failing tests first when practical.
4. Implement the smallest useful change.
5. Run focused tests, then broader gates.
6. Run Playwright/e2e checks for UI flows.
7. Update acceptance checks only with command evidence.
8. Run documentation, cleanup, and update-state through `/finish` or after the slice is done.

## Research Findings

No additional external research is required for TDD itself. If a validation tool or browser automation framework choice changes, route that decision through `spec_003`.

## Design Guidance

Acceptance checks should be executable or at least operationally verifiable. Avoid vague checks like "looks good" unless paired with concrete assertions, screenshots, or browser interactions.

## TDD Unit-Test Plan

- Static tests confirm `/aristotle` and `build` require TDD language, acceptance evidence, and Playwright/e2e for UI work.
- Add fixture tests where a spec cannot be completed until all acceptance checks pass.

## Integration / E2E Expectation

For a simple UI story, the harness should produce a failing component/unit test, implement the behavior, run focused tests, run a Playwright path, and only then update `passes` and `completed`.

## Owned Files

- `skills/build/SKILL.md`
- `skills/test-driven-development/SKILL.md`
- `skills/component-functional-testing/SKILL.md`
- `skills/verification-before-completion/SKILL.md`
- `commands/aristotle.md`
- `commands/build.md`

## Out Of Scope

- Mandating Playwright for non-UI libraries or CLI-only changes.
