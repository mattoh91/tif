---
story_id: story_006
spec_id: spec_002
title: Trinity commands and lifecycle hooks
completed: true
depends_on:
  - spec_001
contracts:
  provides:
    - tif.trinity.workflow
  consumes:
    - tif.artifact_authority.matrix
acceptance_checks:
  - id: check_001
    category: functional
    description: Canonical commands describe a complete project lifecycle.
    steps:
      - "Step 1: Run or inspect the command docs for /socrates, /plato, /aristotle, and /finish."
      - "Step 2: Verify existing commands remain documented as aliases or compatibility entrypoints."
      - "Step 3: Verify each command names its artifact outputs and stop conditions."
    passes: true
  - id: check_002
    category: functional
    description: Hooks support resume, compaction, closeout, and memory review without silently implementing work.
    steps:
      - "Step 1: Inspect SessionStart, PreCompact, SessionEnd, Codex Stop, and update-state hook behavior."
      - "Step 2: Verify hooks refresh context, state audit, sessions, and memory candidates only."
      - "Step 3: Verify implementation and promotion remain explicit command/user actions."
    passes: true
---

# Trinity Commands And Lifecycle Hooks

## Implementation Notes

Introduce phase commands as the primary user mental model:

| Command | Phase | Responsibility | Outputs |
| --- | --- | --- | --- |
| `/socrates` | Requirements | Adaptive Q&A, project intake, PRD story updates, unresolved questions. | `PRD.md`, story planning prompt. |
| `/plato` | Design | Research, architecture, ADR decisions, specs, contracts, state check. | Story `ADR.md`, specs, `contracts.json`. |
| `/aristotle` | Validation | TDD implementation, focused tests, integration/e2e checks, Playwright for UI. | Code, tests, acceptance evidence, spec flags. |
| `/finish` | Closeout | Documentation, cleanup, update-state, staged memory review. | Updated docs/state, memory candidates, preamble. |

Existing `/intake`, `/brainstorm`, `/contracts`, `/build`, `/document`, `/cleanup`, `/preamble`, and `/update-state` can remain as compatibility commands or lower-level expert commands.

Hooks should stay observational and contextual:

- `SessionStart`: inject concise project context, active specs, state audit, and approved memory.
- `PreCompact`: capture session trajectory and stage unresolved context.
- `Codex Stop` and `SessionEnd`: write session notes, run state audit, and stage memory candidates.
- `update-state`: refresh audit/preamble and report pending issues.

## Research Findings

No web research is required for command shape. The workflow names come from the user's requested philosophical trinity.

## Design Guidance

Avoid adding many command names for every sub-step. Let `/plato` call research-enrichment, solution-architect, story-planner, and contract-designer internally.

## TDD Unit-Test Plan

- Static command tests confirm the four canonical commands exist and map to the expected skills.
- Hook tests confirm stop/end hooks do not auto-promote memory or mark specs complete.

## Integration / E2E Expectation

From a fresh request, `/socrates` should gather requirements, `/plato` should produce valid story state and stop for approval, `/aristotle` should implement only approved specs, and `/finish` should document/clean/refresh memory.

## Owned Files

- `commands/*.md`
- `hooks/*`
- `skills/using-tif/SKILL.md`
- `skills/brainstorming/SKILL.md`
- `skills/build/SKILL.md`
- `README.md`

## Out Of Scope

- Brand rename beyond command wording.
- Memory candidate schema implementation.
