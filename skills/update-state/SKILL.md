---
name: update-state
description: Use before clearing, compacting, ending a session, dispatching follow-on agents, or when asked to refresh/check Cutiepie state.
---

# Cutiepie Update State

Use this skill to turn the hook-generated static audit into a curated state refresh.

## Inputs To Read

- `~/.cutiepie/memory/<project-slug>/STATE_AUDIT.md`
- `~/.cutiepie/memory/<project-slug>/PREAMBLE.md`
- `~/.cutiepie/memory/<project-slug>/MEMORY.md`
- `~/.cutiepie/memory/<project-slug>/FAILURES.md`
- recent files under `~/.cutiepie/memory/<project-slug>/SESSIONS/`
- recent git commits, `git status`, `git diff --stat`, and changed files
- `.cutiepie/docs/PRD.md`
- `.cutiepie/docs/feature_list.json`
- `.cutiepie/docs/ARD.md`
- `.cutiepie/docs/ARCHI.md`
- `.cutiepie/docs/CONFIG.md`
- `.cutiepie/docs/PLAN.md`

## Workflow

1. Run `hooks/update-state` from the repo root to generate the latest static audit and mechanical preamble.
2. Read the generated audit and canonical docs.
3. Run or inspect `scripts/check-cutiepie-state.sh .`.
4. Check for stale or orphaned state:
   - `PLAN.md` stage state inconsistent with `feature_list.json`
   - features with `passes: true` but no recorded command/result evidence
   - architecture-affecting code changes not reflected in `ARD.md` or `ARCHI.md`
   - new env vars or tunables missing from `CONFIG.md`
   - durable implementation decisions missing from memory
   - repeated failures missing from `FAILURES.md`
   - dirty or uncommitted work that would confuse a fresh session
5. Update files only when evidence is clear. If a semantic update requires judgment, list the exact suggested edit and ask the user.
6. Regenerate or update the next-session preamble after any changes.
7. Report what changed and what remains stale or uncertain.

## Do Not

- Mark features complete without passing their prescribed steps.
- Duplicate individual feature pass/fail state in `PLAN.md`.
- Invent decisions, citations, or failure modes that were not observed.
- Hide dirty git state from the user.
