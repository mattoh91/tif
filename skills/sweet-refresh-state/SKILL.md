---
name: sweet-refresh-state
description: Use before clearing, compacting, ending a session, dispatching follow-on agents, or when asked to refresh/check Sweet state; audits planning docs, memory, failure modes, git state, and next-session preamble readiness.
---

# Sweet Refresh State

Use this skill to turn the hook-generated static audit into a curated state refresh. The shell hook can detect obvious stale state and write a mechanical preamble; this skill decides what actually needs updating.

## Inputs to Read

- `~/.sweet/memory/<project-slug>/STATE_AUDIT.md`
- `~/.sweet/memory/<project-slug>/PREAMBLE.md`
- `~/.sweet/memory/<project-slug>/MEMORY.md`
- `~/.sweet/memory/<project-slug>/FAILURES.md`
- recent files under `~/.sweet/memory/<project-slug>/SESSIONS/`
- recent git commits, `git status`, `git diff --stat`, and changed files
- `.sweet/PRD.md` or `docs/sweet/PRD.md`
- `.sweet/FRD.md` or `docs/sweet/FRD.md`
- `.sweet/PLAN.md` or `docs/sweet/PLAN.md`
- `.sweet/ARD.md` or `docs/sweet/ARD.md`
- `.sweet/ARCHI.md` or `docs/sweet/ARCHI.md`
- `.sweet/CAVEATS.md` or `docs/sweet/CAVEATS.md`

## Workflow

1. Run `hooks/sweet-refresh-state` from the repo root to generate the latest static audit and mechanical preamble.
2. Read the generated audit and the files listed above.
3. Check for stale or orphaned state:
   - completed feature/component work not reflected in FRD progress
   - PLAN tasks inconsistent with FRD status
   - architecture-affecting code changes not reflected in ARD
   - changed components/interfaces not reflected in ARCHI diagrams
   - assumptions, deviations, or limitations missing from CAVEATS
   - durable implementation decisions missing from MEMORY
   - repeated failures or root causes missing from FAILURES
   - dirty or uncommitted work that would confuse a fresh session
4. Update files only when the evidence is clear. If a semantic update requires judgment, list the exact suggested edit and ask the user.
5. Regenerate or update the next-session preamble after any changes.
6. Report what changed and what remains stale or uncertain.

## Review Standard

State is refreshed when:

- git status is understood and intentionally clean or intentionally dirty
- feature/component progress in FRD matches the implemented state
- PLAN, ARD, ARCHI, and CAVEATS are not obviously stale relative to recent commits/diff
- MEMORY and FAILURES contain durable lessons worth carrying forward
- `~/.sweet/memory/<project-slug>/PREAMBLE.md` names the next task, relevant gates, and key files for the next session

## Do Not

- Invent decisions or failure modes that were not observed.
- Mark features/components complete without passing gates.
- Rewrite large planning docs just to make them look fresh.
- Hide dirty git state from the user.
