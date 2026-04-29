---
name: capturing-failure-modes
description: Use before compacting, clearing, ending a session, or after repeated mistakes to summarize failure patterns, root causes, fixes, and durable lessons into ~/.sweet/memory.
---

# Capturing Failure Modes

Use this skill to turn session problems into reusable memory.

## When to Run

- Before `clear`, `compact`, or ending a long session
- After the same mistake happens more than once
- After debugging reveals a misleading assumption
- After a component acceptance gate failed for a non-obvious reason

Claude-compatible hooks persist raw session markers under `~/.sweet/memory/<project>/SESSIONS/`. Hooks do not load this skill. The agent uses this skill to summarize and update durable memory.

## Output Files

- `~/.sweet/memory/<project-slug>/FAILURES.md`
- `~/.sweet/memory/<project-slug>/MEMORY.md` when the lesson affects future implementation
- `~/.sweet/memory/<project-slug>/SESSIONS/<YYYY-MM-DD>.md` for session notes

## Workflow

1. Identify the project slug from git remote or directory name.
2. Read recent session notes, current git diff, recent commits, `.sweet/PLAN.md` or `docs/sweet/PLAN.md`, and `.sweet/FRD.md` or `docs/sweet/FRD.md` if present.
3. Extract repeated or high-cost failure modes. Ignore one-off trivia.
4. Append concise entries to `FAILURES.md` using the format below.
5. If the lesson changes how future agents should work in this repo, append a short entry to `MEMORY.md`.
6. Keep entries factual. Do not invent errors that were not observed.

## Failure Entry Format

```markdown
## YYYY-MM-DD — Short Pattern Name

Context:
- What was being attempted.

Pattern:
- What went wrong or kept recurring.

Root cause:
- The concrete cause, not a vague label.

Fix:
- What resolved it.

Prevention:
- What future sessions should do differently.

References:
- Commit, file, test, or plan pointers.
```

## Quality Bar

Good entries are short, reusable, and specific enough to change future behavior. Bad entries are blame, vibes, or generic advice like "be careful."
