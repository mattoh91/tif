---
name: multi-agent-adapter
description: Use whenever Tif dispatches subagents, reviewers, implementers, or parallel workers across Claude Code, Codex, Cursor, Copilot, Gemini, or unknown hosts.
---

# Multi-Agent Adapter

Use this skill as the runtime dispatch contract for story specs.

## Task Packet

Every worker gets:

- Role: implementer, reviewer, explorer, debugger, or custom role.
- Goal: one concrete spec or review outcome.
- Scope: allowed files, symbols, contracts, and behavior.
- Out of scope: what not to touch.
- Context: the spec file whole, the PRD story row it implements (verbatim), contracts, ADR decisions, config, failing tests, review comments.
- Inputs: contract schemas, function args, API payloads, UI state/props, external payloads.
- Output contract: exact response format.
- Gates: TDD tests, acceptance checks, lint/typecheck/build commands.
- Integration rules: whether the worker may edit files or report only.

Workers must not rely on hidden conversation history.

## Packet Fidelity

Distilling context into a packet is where load-bearing words get dropped. Rules:

- Pass the spec file content whole, never a summary of it. A worker built from a
  summary faithfully builds the summary's omissions.
- Quote acceptance criteria and contract fields verbatim from the spec; do not
  paraphrase them into the packet.
- Every number, count, or limit in a packet names exactly what it counts
  ("documents the user pinned", not "the pin count") — ambiguous referents become
  wrong code.
- A reviewer's packet must be a superset of the builder's packet, adding the PRD
  story row and ADR decisions. A reviewer graded only against the builder's brief
  inherits the brief's omissions and approves the wrong thing.

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
