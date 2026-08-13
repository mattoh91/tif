---
name: subagent-driven-development
description: Compatibility entrypoint for implementing Tif story specs with workers or inline fallback.
---

# Subagent-Driven Development

This skill now executes story specs from `.tif/plans/story_*/specs/`.

## Workflow

1. Run `scripts/check-tif-state.sh .`.
2. Read the PRD, architecture, config, story `ADR.md`, `contracts.json`, and specs.
3. Select incomplete specs whose dependencies are complete.
4. Use `multi-agent-adapter` for all worker dispatch decisions.
5. Dispatch in parallel only when specs have non-overlapping files and contracts.
6. Give each worker a self-contained task packet with:
   - spec markdown and frontmatter, passed whole (never a summary — see
     `multi-agent-adapter` → Packet Fidelity)
   - the PRD story row the spec implements, verbatim
   - relevant contract schemas
   - allowed/out-of-scope files
   - TDD expectations
   - acceptance checks and gate commands
7. Parent session reviews results, runs integration gates, and updates spec frontmatter only when verified. The final review compares the work against the spec and PRD story text, not against the packet.
8. Run documentation, cleanup, and state refresh.

## Completion Rule

`completed: true` means every acceptance check in that spec has `passes: true` and the verification evidence was produced in the current work.
