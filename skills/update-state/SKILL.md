---
name: update-state
description: Use to refresh Tif memory and preamble from PRD, story specs, contracts, git status, and state validation.
---

# Update State

Run `hooks/update-state` or `hooks/update-state --hook`.

State refresh reads:

- `.tif/docs/PRD.md`
- `.tif/docs/ARCHI.md`
- `.tif/docs/CONFIG.md`
- `.tif/plans/story_*/ADR.md`
- `.tif/plans/story_*/contracts.json`
- `.tif/plans/story_*/specs/spec_*.md`
- git status and recent commits

State refresh writes:

- `~/.tif/memory/<project-slug>/STATE_AUDIT.md`
- `~/.tif/memory/<project-slug>/PREAMBLE.md`
- `~/.tif/memory/<project-slug>/SESSIONS/<date>.md`
- `~/.tif/memory/<project-slug>/CANDIDATES.jsonl` when stale-state or closeout issues are detected

When `docs/ppt/.drift.json` exists, run `node scripts/deck/drift.mjs check .tif/docs/ARCHI.md docs/ppt/.drift.json` and report a stale slide-deck diagram as a closeout issue (regenerate with `/deck`).

Run `documentation` and `cleanup` before state refresh when ending a session. Run `memory-review` before promoting any candidate into durable memory, skills, docs, or tests.
