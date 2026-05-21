# Cutiepie Session Trace

This trace defines the expected lifecycle for a typical Cutiepie-managed coding session and how to verify each trigger.

## 1. Start or Resume Session

Expected host trigger:

- Claude Code: `SessionStart` from `hooks/hooks.json`
- Codex: `SessionStart` from `.codex/hooks.json` when `hooks = true`

Expected script:

- `hooks/session-start`

Expected effect:

- Injects `using-cutiepie`
- Injects recent git status/log
- Injects Cutiepie memory, failures, latest session, canonical `.cutiepie/docs/` snippets, and the state-contract report when present

Verify locally:

```bash
CLAUDE_PLUGIN_ROOT="$PWD" hooks/run-hook.cmd session-start | node -e "let s=''; process.stdin.on('data',d=>s+=d); process.stdin.on('end',()=>{const j=JSON.parse(s); if(!j.hookSpecificOutput?.additionalContext) throw new Error('missing context'); console.log('session-start ok')})"
```

## 2. First User Prompt

Expected skill:

- `using-cutiepie`

Expected behavior:

- The agent checks whether a skill applies before answering or acting.
- The agent loads process skills before implementation skills.

Manual verification:

- Start a new host session and ask for a Cutiepie workflow.
- Confirm the first response states which skill is being used when applicable.

## 3. Scaffolding or New Feature

Expected skills:

- `scaffolding-repo` for new/under-structured repos
- `brainstorming` for new feature/product work
- `prd-discovery`, `feature-list-builder`, `research-enrichment`, `solution-architect`, `implementation-sequencer`, and `writing-plans` as planning advances

Expected artifacts:

- `.cutiepie/docs/PRD.md`
- `.cutiepie/docs/feature_list.json`
- `.cutiepie/docs/ARD.md`
- `.cutiepie/docs/ARCHI.md`
- `.cutiepie/docs/CONFIG.md`
- `.cutiepie/docs/PLAN.md`

`CONFIG.md` must name the settings/config owner and document all hyperparameters and tunables.

Manual verification:

```text
Use Cutiepie to scaffold this repo.
Use Cutiepie to brainstorm and plan this feature.
```

## 4. Implementation

Expected skills:

- `subagent-driven-development` when subagents are available
- `executing-plans` fallback when executing inline
- `test-driven-development` inside implementation
- `component-functional-testing` for feature steps and component contract checks
- `requesting-code-review` before moving on

Expected state updates:

- Feature `passes` state updated in `feature_list.json` only after prescribed steps pass
- Phase/workflow progress updated in `PLAN.md`
- Component contract checks recorded when relevant
- Meaningful decisions/deviations written to Cutiepie memory or `ARD.md`
- Coherent commits after completed slices

Manual verification:

```bash
git status --short
git log --oneline -5
```

Check `feature_list.json`, `PLAN.md`, and memory files.

## 5. Refresh State Before Clear, Compact, or Handoff

Expected manual command:

- `/update-state`

Expected skill:

- `update-state`

Expected script:

- `hooks/update-state`

Expected artifacts:

- `~/.cutiepie/memory/<project-slug>/STATE_AUDIT.md`
- `~/.cutiepie/memory/<project-slug>/PREAMBLE.md`

Verify locally:

```bash
hooks/update-state
```

## 6. Compact

Expected host trigger:

- Claude Code: `PreCompact` with matcher `manual|auto`

Expected scripts:

- `hooks/pre-compact`
- `hooks/update-state --hook`

Expected artifacts:

- raw hook payload under `~/.cutiepie/memory/<project-slug>/SESSIONS/`
- daily session note
- refreshed `STATE_AUDIT.md`
- refreshed `PREAMBLE.md`

Verify locally:

```bash
printf '{"hook_event_name":"PreCompact","trigger":"manual"}' | hooks/pre-compact | node -e "let s=''; process.stdin.on('data',d=>s+=d); process.stdin.on('end',()=>{JSON.parse(s); console.log('pre-compact ok')})"
```

## 7. Stop or End Session

Expected host trigger:

- Claude Code: `SessionEnd`
- Codex: `Stop`

Expected scripts:

- Claude Code: `hooks/session-end`, then `hooks/update-state --hook`
- Codex: `hooks/codex-stop`, then `hooks/update-state --hook`

Expected artifacts:

- session note under `~/.cutiepie/memory/<project-slug>/SESSIONS/`
- refreshed `STATE_AUDIT.md`
- refreshed `PREAMBLE.md`

Verify locally:

```bash
printf '{"hook_event_name":"SessionEnd"}' | hooks/session-end | node -e "let s=''; process.stdin.on('data',d=>s+=d); process.stdin.on('end',()=>{JSON.parse(s); console.log('session-end ok')})"
printf '{"hook_event_name":"Stop","cwd":"'"$PWD"'","session_id":"test"}' | hooks/codex-stop | node -e "let s=''; process.stdin.on('data',d=>s+=d); process.stdin.on('end',()=>{const j=JSON.parse(s); if(j.continue !== true) throw new Error('bad stop output'); console.log('codex-stop ok')})"
```

## 8. Fresh Session Handoff

Expected skill:

- `preamble`

Expected source file:

- `~/.cutiepie/memory/<project-slug>/PREAMBLE.md`

Manual verification:

```text
Use the preamble skill to generate my session context.
```

The generated context should name the current implementation phase, next feature/task, feature steps to run, important decisions, failure modes, recent commits, dirty git state, and key files to inspect.
