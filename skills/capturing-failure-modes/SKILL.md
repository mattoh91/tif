---
name: capturing-failure-modes
description: Use when a failure, stale state issue, or repeated mistake should be recorded for future Cutiepie sessions.
---

# Capturing Failure Modes

Record durable lessons in `~/.cutiepie/memory/<project-slug>/FAILURES.md`.

Read recent session notes, git diff, commits, story specs, contracts, and state checker output. Capture:

- trigger
- root cause
- detection signal
- prevention rule
- affected story/spec if any
- verification command

Update story ADR or specs when the lesson changes project behavior.
