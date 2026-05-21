# Cutiepie — Contributor Guidelines

This repository contains Cutiepie, an opinionated SWE harness that works across Claude Code and Codex.

## Local Priority

Treat Cutiepie as the active product. External upstream contribution rules are not the default operating policy here unless the user explicitly says they are preparing an upstream contribution.

When working in this repo:

1. Preserve cross-harness behavior for Claude Code and Codex. Shared workflow logic belongs in `skills/`; Claude Code lifecycle automation belongs in `hooks/` and `commands/`; Codex must package shared skills and provide skill-side fallbacks for anything hook-dependent.
2. Keep changes grounded in active `.cutiepie/docs/PRD.md`, `.cutiepie/docs/feature_list.json`, and `.cutiepie/docs/PLAN.md`. Root-level `USERSTORIES.md` and `PLAN.md` are historical harness-maintenance archives unless explicitly referenced.
3. Prefer small phases with clear verification over broad rewrites.
4. Do not add third-party runtime dependencies unless the user explicitly approves them.
5. When modifying skills, treat them as behavior-shaping code: keep wording deliberate, test triggering, and avoid casual prose churn.
6. Follow `docs/cutiepie/AGENTIC_ENGINEERING_GUIDELINES.md` for Cutiepie's shared engineering contract: feature-level progress, component-level contracts, closed verification loops, memory updates, and commit hygiene.

## Harness Goals

Cutiepie provides:

- structured project artifacts under `.cutiepie/docs/`: `PRD.md`, `feature_list.json`, `ARD.md`, `ARCHI.md`, `CONFIG.md`, and `PLAN.md`
- feature specs backed by automated e2e/user-flow, API scenario, CLI, DTO/data-contract, or equivalent project-specific checks
- component contract gates backed by DTO/data-contract checks, schema checks, adapter payload checks, public API behavior, or equivalent boundary verification
- context-aware requirements probing with no-network fallbacks
- out-of-tree memory under `~/.cutiepie/memory/<project-slug>/`
- failure-mode capture and session bootstrap via `/preamble`
- repo scaffolding for common init scripts, Make targets, CI checks, and planning skeletons

## Artifact Rules

Generated and active artifacts for this harness and downstream projects must live under `.cutiepie/docs/`. Root-level `PLAN.md` and `USERSTORIES.md` are historical harness-maintenance archives unless explicitly referenced.

Active Cutiepie project artifacts are only the top-level files under `.cutiepie/docs/`: `PRD.md`, `feature_list.json`, `ARD.md`, `ARCHI.md`, `CONFIG.md`, and `PLAN.md`. Dated files under `docs/cutiepie/specs/`, `docs/cutiepie/plans/`, or `docs/plans/`, old `.cutiepie/*.md` files, and root-level planning files are historical or harness-maintenance artifacts unless the user explicitly says to migrate their contents. Do not treat archives as satisfying the active Cutiepie state gate.

The active artifacts may be intentionally lightweight for small projects, but their responsibilities should stay distinct. `feature_list.json` is the machine-readable feature/test source of truth and owns individual feature completion through `passes`. `PLAN.md` is the human workflow checklist and phase-level progress tracker; it must not duplicate individual feature pass/fail state. `ARD.md` includes assumptions and caveats when they affect decisions.

All hyperparameters and tunable settings belong in a proper settings/config owner in the project code and must be documented in active `CONFIG.md`: model names, temperatures, token limits, thresholds, retry counts, timeouts, polling intervals, batch sizes, feature flags, and similar values. Do not scatter magic numbers or configuration literals through implementation code without documenting why they are intentionally local constants.

## Subagent Divisibility

Write feature specs so a fresh subagent can implement a feature or component task without inherited conversation context. A task is not dispatchable until `feature_list.json` and `ARCHI.md` define the feature steps, system/module boundary, allowed files, input and output DTO/data shapes, neighbor contracts, settings/config contract, and relevant checks. If those details are missing, update the canonical docs before dispatching work.

## Verification

Use the existing test harness where possible:

- `tests/skill-triggering/run-all.sh`
- `tests/claude-code/run-skill-tests.sh`
- `tests/codex-plugin-sync/test-sync-to-codex-plugin.sh`

If a test requires unavailable local tools, state that clearly and verify with the closest available static checks.
