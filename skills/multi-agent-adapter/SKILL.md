---
name: multi-agent-adapter
description: Use whenever Cutiepie dispatches subagents, reviewers, implementers, or parallel workers across Claude Code, Codex, Cursor, Copilot, Gemini, or unknown hosts.
---

# Multi-Agent Adapter

Use this skill as the runtime dispatch contract for story specs.

## Task Packet

Every worker gets:

- Role: implementer, reviewer, explorer, debugger, or custom role.
- Goal: one concrete spec or review outcome.
- Scope: allowed files, symbols, contracts, and behavior.
- Out of scope: what not to touch.
- Context: PRD/story/spec excerpts, contracts, ADR decisions, config, failing tests, review comments.
- Inputs: contract schemas, function args, API payloads, UI state/props, external payloads.
- Output contract: exact response format.
- Gates: TDD tests, acceptance checks, lint/typecheck/build commands.
- Integration rules: whether the worker may edit files or report only.

Workers must not rely on hidden conversation history.

## Host Mapping

| Host | Adapter Behavior |
| --- | --- |
| Claude Code | Use native `Task` with named agent types when available. |
| Codex | Use generic workers when multi-agent support is available; include named-agent prompt content in the message. |
| Cursor | Run inline using the same packet. |
| Copilot CLI | Run inline unless a reliable worker surface is explicitly available. |
| Gemini CLI | Run inline. |
| Unknown host | Prefer inline fallback. |

## Parallel Dispatch

Dispatch multiple workers only when:

- specs are dependency-ready
- file scopes do not overlap
- contract providers/consumers are clear
- parent session can integrate results

After workers return, run integration gates and update specs only after checks pass.
