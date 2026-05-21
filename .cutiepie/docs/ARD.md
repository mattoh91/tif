# Cutiepie Architecture Decisions

## ADR-001: Canonical Artifact Directory

Status: Accepted

Problem:

- Agents were forced to choose between `.cutiepie/`, `docs/cutiepie/`, root-level maintenance docs, and dated archives.

Decision:

- Active project artifacts live only under `.cutiepie/docs/`.

Consequences:

- Hooks and skills can validate one path.
- Historical docs remain useful only as archives or migration sources.

## ADR-002: Split Human Workflow From Feature Completion

Status: Accepted

Problem:

- `PLAN.md` and feature progress can become inconsistent if both track per-feature completion.

Decision:

- `feature_list.json` owns individual feature completion through `passes`.
- `PLAN.md` owns workflow and phase-level progress only.

Consequences:

- Hooks can mechanically enforce ownership boundaries.
- Humans still get a readable checklist without duplicating feature state.

## ADR-003: Spec-Driven Development With Internal TDD

Status: Accepted

Problem:

- Visible TDD-step plans are too implementation-centric for high-level progress tracking.

Decision:

- Feature specs and feature steps are the visible completion contract.
- Implementer subagents use TDD internally.

Consequences:

- Completion claims are tied to feature behavior, not just unit-test progress.
