---
name: preamble
description: Use when starting or resuming work after a clear/compact/new session to generate a copy-paste context block from ~/.cutiepie memory, git logs, FRD progress, and PLAN status.
---

# Preamble

Generate a concise context block for a fresh session. This skill reads project state and prints text for the user to paste into the next prompt. It does not mutate files unless the user explicitly asks.

## Inputs to Read

Use what exists:

- `~/.cutiepie/memory/<project-slug>/MEMORY.md`
- `~/.cutiepie/memory/<project-slug>/FAILURES.md`
- `~/.cutiepie/memory/<project-slug>/SESSIONS/` recent files
- recent git commits
- current git status
- recent git diff/stat
- `.cutiepie/FRD.md` or `docs/cutiepie/FRD.md`
- `.cutiepie/PLAN.md` or `docs/cutiepie/PLAN.md`
- `.cutiepie/CAVEATS.md` or `docs/cutiepie/CAVEATS.md`
- `.cutiepie/CONFIG.md` or `docs/cutiepie/CONFIG.md`
- feature/component source, test, DTO, schema, adapter, and gate files referenced by the current FRD/PLAN task

## Workflow

1. Derive the project slug from git remote or directory name.
2. Read the files above if present. Do not fail if some are missing.
3. Summarize only what is needed to resume work:
   - project goal
   - current feature and component
   - completed components
   - next task
   - feature acceptance gate and component contract gate to run next
   - key component code references to inspect before editing
   - relevant decisions/caveats
   - relevant settings/config owner and tunables
   - known failure modes
   - dirty git state
4. Include code references only when they help the next session start safely:
   - component entry points
   - public interfaces, DTOs, schemas, adapters, or boundary modules
   - settings/config owner and CONFIG.md entries for relevant hyperparameters
   - feature acceptance gate and component contract gate files
   - focused unit/integration tests
   - recently changed files from `git diff --stat` or recent commits
   - files with known caveats or failure modes
5. Prefer exact repo-relative paths and symbol names. Include line numbers when you have already inspected the file and the line is stable enough to be useful.
6. Do not flood the preamble with every file touched. Pick the minimum set the next agent should read before proceeding.
7. Print the preamble in the format below.

## Output Format

```markdown
Use this as the first message in a fresh agent session:

<cutiepie-preamble>
Project: ...
Current goal: ...
Current state: ...
Completed components: ...
Next feature/component/task: ...
Feature acceptance gate: ...
Component contract gate: ...
Code references to inspect:
- path/to/component.ts — component entry point; key symbols: ...
- path/to/component.test.ts — focused tests for ...
- path/to/contract.test.ts — automated component contract gate
- path/to/feature.spec.ts — automated feature acceptance gate
Important decisions: ...
Relevant config: ...
Known caveats/failure modes: ...
Relevant files:
- ...
Recent commits:
- ...
Working tree:
- ...
</cutiepie-preamble>
```

Keep it under 1200 words unless the user asks for a full handoff.
