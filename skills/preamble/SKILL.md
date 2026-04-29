---
name: preamble
description: Use when starting or resuming work after a clear/compact/new session to generate a copy-paste context block from ~/.sweet memory, git logs, FRD progress, and PLAN status.
---

# Preamble

Generate a concise context block for a fresh session. This skill reads project state and prints text for the user to paste into the next prompt. It does not mutate files unless the user explicitly asks.

## Inputs to Read

Use what exists:

- `~/.sweet/memory/<project-slug>/MEMORY.md`
- `~/.sweet/memory/<project-slug>/FAILURES.md`
- `~/.sweet/memory/<project-slug>/SESSIONS/` recent files
- recent git commits
- current git status
- recent git diff/stat
- `.sweet/FRD.md` or `docs/sweet/FRD.md`
- `.sweet/PLAN.md` or `docs/sweet/PLAN.md`
- `.sweet/CAVEATS.md` or `docs/sweet/CAVEATS.md`
- component source/test files referenced by the current FRD/PLAN task

## Workflow

1. Derive the project slug from git remote or directory name.
2. Read the files above if present. Do not fail if some are missing.
3. Summarize only what is needed to resume work:
   - project goal
   - current component/epic
   - completed components
   - next task
   - acceptance gate to run next
   - key component code references to inspect before editing
   - relevant decisions/caveats
   - known failure modes
   - dirty git state
4. Include code references only when they help the next session start safely:
   - component entry points
   - public interfaces, DTOs, schemas, adapters, or boundary modules
   - acceptance gate files
   - focused unit/integration tests
   - recently changed files from `git diff --stat` or recent commits
   - files with known caveats or failure modes
5. Prefer exact repo-relative paths and symbol names. Include line numbers when you have already inspected the file and the line is stable enough to be useful.
6. Do not flood the preamble with every file touched. Pick the minimum set the next agent should read before proceeding.
7. Print the preamble in the format below.

## Output Format

```markdown
Use this as the first message in a fresh agent session:

<sweet-preamble>
Project: ...
Current goal: ...
Current state: ...
Completed components: ...
Next component/task: ...
Acceptance gate: ...
Code references to inspect:
- path/to/component.ts — component entry point; key symbols: ...
- path/to/component.test.ts — focused tests for ...
- path/to/acceptance.spec.ts — automated component acceptance gate
Important decisions: ...
Known caveats/failure modes: ...
Relevant files:
- ...
Recent commits:
- ...
Working tree:
- ...
</sweet-preamble>
```

Keep it under 1200 words unless the user asks for a full handoff.
