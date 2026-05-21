# Cutiepie Product Requirements

## Problem Statement

Cutiepie is a personal cross-harness SWE workflow for Claude Code and Codex. It should keep long-running software work recoverable by making requirements, feature specs, architecture, configuration, progress, hooks, and memory explicit.

The harness carried redundant planning surfaces from its Superpowers base: dated spec/plan archives, root maintenance docs, old `.cutiepie/*.md` expectations, FRD/CAVEATS splits, and visible TDD-heavy plans. The active workflow should be simpler and more deterministic.

## Users

- Primary user: a developer using Claude Code or Codex to build and maintain projects with agent help.
- Secondary user: a fresh agent session or subagent that must recover state without hidden conversation context.

## User Stories

| ID | User Story | Acceptance Notes | Priority |
| --- | --- | --- | --- |
| US001 | As a developer, I want all active project artifacts under `.cutiepie/docs/` so agents do not choose between duplicate locations. | Hooks, skills, templates, and docs point to `.cutiepie/docs/` only. | High |
| US002 | As a developer, I want `feature_list.json` to own feature requirements and pass/fail state so automation has a single machine-readable source. | Schema validation catches missing fields, duplicate IDs, bad steps, and invalid pass state. | High |
| US003 | As a developer, I want `PLAN.md` to own workflow checklist state only so human progress is readable without duplicating feature completion. | Validator blocks checked PLAN lines that duplicate feature pass/fail state. | High |
| US004 | As a fresh agent, I want session hooks to inject the active docs and state-contract report so I know the next correct skill. | SessionStart includes canonical docs and validator output. | High |
| US005 | As a developer, I want TDD to be internal to implementation subagents while visible completion is spec-driven. | Skills require feature steps to pass before `passes` changes to true. | High |

## Success Criteria

- `scripts/check-cutiepie-state.sh .` validates canonical docs and ownership boundaries.
- `hooks/update-state` writes state audits from the new contract.
- `hooks/session-start` injects the new canonical docs.
- Core skills route planning through PRD, feature list, research enrichment, architecture, sequencing, and workflow planning.

## Non-Goals

- Preserve the old FRD/CAVEATS artifact split.
- Treat root-level planning files as active project state.
- Add third-party runtime dependencies.
