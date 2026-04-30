# Sweet — Contributor Guidelines

This repository contains Sweet, an opinionated SWE harness that works across Claude Code and Codex.

## Local Priority

Treat Sweet as the active product. External upstream contribution rules are not the default operating policy here unless the user explicitly says they are preparing an upstream contribution.

When working in this repo:

1. Preserve cross-harness behavior for Claude Code and Codex. Shared workflow logic belongs in `skills/`; Claude Code lifecycle automation belongs in `hooks/` and `commands/`; Codex must package shared skills and provide skill-side fallbacks for anything hook-dependent.
2. Keep changes grounded in the painpoints in `USERSTORIES.md` and the phased execution plan in `PLAN.md`.
3. Prefer small phases with clear verification over broad rewrites.
4. Do not add third-party runtime dependencies unless the user explicitly approves them.
5. When modifying skills, treat them as behavior-shaping code: keep wording deliberate, test triggering, and avoid casual prose churn.
6. Follow `docs/sweet/AGENTIC_ENGINEERING_GUIDELINES.md` for Sweet's shared engineering contract: feature-level progress, component-level contracts, closed verification loops, memory updates, and commit hygiene.

## Harness Goals

Sweet provides:

- structured project artifacts under `.sweet/` or `docs/sweet/`: `PRD.md`, `FRD.md`, `ARD.md`, `CAVEATS.md`, `ARCHI.md`, and `PLAN.md`
- feature acceptance gates backed by automated e2e/user-flow, API scenario, CLI, or equivalent project-specific checks
- component contract gates backed by DTO/data-contract checks, schema checks, adapter payload checks, public API behavior, or equivalent boundary verification
- context-aware requirements probing with no-network fallbacks
- out-of-tree memory under `~/.sweet/memory/<project-slug>/`
- failure-mode capture and session bootstrap via `/preamble`
- repo scaffolding for common init scripts, Make targets, CI checks, and planning skeletons

## Artifact Rules

Root-level `PLAN.md` and `USERSTORIES.md` describe work on this harness itself. Generated artifacts for downstream projects should default to `.sweet/` or `docs/sweet/` to avoid colliding with harness-maintenance docs.

## Verification

Use the existing test harness where possible:

- `tests/skill-triggering/run-all.sh`
- `tests/claude-code/run-skill-tests.sh`
- `tests/codex-plugin-sync/test-sync-to-codex-plugin.sh`

If a test requires unavailable local tools, state that clearly and verify with the closest available static checks.
