---
name: update-state
description: Use before clearing, compacting, ending a session, dispatching follow-on agents, or when asked to refresh/check Cutiepie state; audits planning docs, memory, failure modes, git state, and next-session preamble readiness.
---

# Cutiepie Update State

Use this skill to turn the hook-generated static audit into a curated state refresh. The shell hook can detect obvious stale state and write a mechanical preamble; this skill decides what actually needs updating.

## Inputs to Read

- `~/.cutiepie/memory/<project-slug>/STATE_AUDIT.md`
- `~/.cutiepie/memory/<project-slug>/PREAMBLE.md`
- `~/.cutiepie/memory/<project-slug>/MEMORY.md`
- `~/.cutiepie/memory/<project-slug>/FAILURES.md`
- recent files under `~/.cutiepie/memory/<project-slug>/SESSIONS/`
- recent git commits, `git status`, `git diff --stat`, and changed files
- `.cutiepie/PRD.md` or `docs/cutiepie/PRD.md`
- `.cutiepie/FRD.md` or `docs/cutiepie/FRD.md`
- `.cutiepie/PLAN.md` or `docs/cutiepie/PLAN.md`
- `.cutiepie/ARD.md` or `docs/cutiepie/ARD.md`
- `.cutiepie/ARCHI.md` or `docs/cutiepie/ARCHI.md`
- `.cutiepie/CONFIG.md` or `docs/cutiepie/CONFIG.md`
- `.cutiepie/CAVEATS.md` or `docs/cutiepie/CAVEATS.md`

## Workflow

1. Run `hooks/update-state` from the repo root to generate the latest static audit and mechanical preamble.
2. Read the generated audit and the files listed above.
3. Check for stale or orphaned state:
   - completed feature/component work not reflected in FRD progress
   - PLAN tasks inconsistent with FRD status
   - architecture-affecting code changes not reflected in ARD
   - changed components/interfaces not reflected in ARCHI diagrams
   - new hyperparameters/tunables not reflected in CONFIG or the settings/config owner
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
- CONFIG documents settings owners, defaults, allowed values, and hyperparameters/tunables touched by recent work
- MEMORY and FAILURES contain durable lessons worth carrying forward
- `~/.cutiepie/memory/<project-slug>/PREAMBLE.md` names the next task, relevant gates, and key files for the next session

## Do Not

- Invent decisions or failure modes that were not observed.
- Mark features/components complete without passing gates.
- Rewrite large planning docs just to make them look fresh.
- Hide dirty git state from the user.
