---
name: update-state
description: Use to refresh Cutiepie memory and preamble from PRD, story specs, contracts, git status, and state validation.
---

# Update State

Run `hooks/update-state` or `hooks/update-state --hook`.

State refresh reads:

- `.cutiepie/docs/PRD.md`
- `.cutiepie/docs/ARCHI.md`
- `.cutiepie/docs/CONFIG.md`
- `.cutiepie/plans/story_*/plan.md`
- `.cutiepie/plans/story_*/ADR.md`
- `.cutiepie/plans/story_*/contracts.json`
- `.cutiepie/plans/story_*/specs/spec_*.md`
- git status and recent commits

Run `documentation` and `cleanup` before state refresh when ending a session.
