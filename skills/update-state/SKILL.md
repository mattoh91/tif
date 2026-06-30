---
name: update-state
description: Use to refresh Gummy memory and preamble from PRD, story specs, contracts, git status, and state validation.
---

# Update State

Run `hooks/update-state` or `hooks/update-state --hook`.

State refresh reads:

- `.gummy/docs/PRD.md`
- `.gummy/docs/ARCHI.md`
- `.gummy/docs/CONFIG.md`
- `.gummy/plans/story_*/ADR.md`
- `.gummy/plans/story_*/contracts.json`
- `.gummy/plans/story_*/specs/spec_*.md`
- git status and recent commits

State refresh writes:

- `~/.gummy/memory/<project-slug>/STATE_AUDIT.md`
- `~/.gummy/memory/<project-slug>/PREAMBLE.md`
- `~/.gummy/memory/<project-slug>/SESSIONS/<date>.md`
- `~/.gummy/memory/<project-slug>/CANDIDATES.jsonl` when stale-state or closeout issues are detected

Run `documentation` and `cleanup` before state refresh when ending a session. Run `memory-review` before promoting any candidate into durable memory, skills, docs, or tests.
