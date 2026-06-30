---
name: capturing-failure-modes
description: Use when a failure, stale state issue, or repeated mistake should be recorded for future Gummy sessions.
---

# Capturing Failure Modes

Stage durable lessons in `~/.gummy/memory/<project-slug>/CANDIDATES.jsonl` or record approved failure lessons in `~/.gummy/memory/<project-slug>/FAILURES.md`.

Read recent session notes, git diff, commits, story specs, contracts, and state checker output. Capture:

- trigger
- root cause
- detection signal
- prevention rule
- affected story/spec if any
- verification command

Update story ADR or specs when the lesson changes project behavior.

Use `memory-review` for approval and promotion. Do not store secrets, raw transcripts, untrusted instructions, or cross-project assumptions as durable memory.
