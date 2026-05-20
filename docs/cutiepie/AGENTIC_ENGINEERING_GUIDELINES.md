# Agentic Engineering Guidelines

These guidelines define Cutiepie's default engineering contract for long-running, multi-agent SWE work. Merge them with project-specific instructions as needed.

Tradeoff: these rules bias toward caution, clarity, and recoverability over raw speed. For trivial tasks, use judgment.

## Core Model

Cutiepie tracks work at two levels:

- **Features** are the user-visible progress unit. A feature describes the capability that must work end to end.
- **Components** are the implementation ownership unit. A component has clear boundaries, DTO/data-contract shapes, and a focused contract gate.

Every feature should have a feature acceptance gate. Every component touched by that feature should have a component contract gate. Feature gates prove the user/system outcome; component gates make the boundaries safe for independent agents to implement and review.

## Multi-Agent Context Contract

Subagents and fresh sessions must be able to reconstruct the current state without inheriting hidden context. To make that possible:

- Commit meaningful progress with descriptive messages after each coherent component or feature slice.
- Update `.cutiepie/FRD.md` or `docs/cutiepie/FRD.md` when feature or component status changes.
- Update `~/.cutiepie/memory/<project-slug>/MEMORY.md` with durable decisions, deviations, and integration notes.
- Update `~/.cutiepie/memory/<project-slug>/FAILURES.md` when a repeated failure mode, root cause, or fix should affect future work.
- Keep DTOs, schemas, public interfaces, adapters, and boundary modules easy to find from the plan, preamble, and recent commits.

Git history, Cutiepie memory, FRD progress, and explicit contract gates are the shared substrate that lets multiple agents work in parallel without relying on one session's context window.

## Think Before Coding

Do not assume. Do not hide confusion. Surface tradeoffs.

Before implementing:

- State assumptions explicitly when they affect the design, boundary, or test strategy.
- If multiple interpretations exist, present them instead of silently choosing.
- If a simpler approach exists, say so.
- Push back when the requested path creates avoidable complexity, brittle behavior, or unclear ownership.
- If the task is unclear enough that implementation would be guesswork, stop and ask.

## Simplicity First

Write the minimum code that solves the problem. Nothing speculative.

- Do not add features beyond what was asked.
- Do not add abstractions for single-use code.
- Do not add flexibility, configurability, or indirection that the current requirement does not need.
- Do not add error handling for impossible scenarios.
- Prefer YAGNI, KISS, DRY, and SOLID in that order when they conflict. Avoid duplication that creates risk, but do not introduce abstractions just to satisfy DRY mechanically.
- If the solution is much longer than the problem warrants, simplify before continuing.

## Surgical Changes

Touch only what the task requires. Clean up only the mess your change creates.

When editing existing code:

- Do not improve adjacent code, comments, names, or formatting unless needed for the requested change.
- Do not refactor unrelated code.
- Match existing style, even when a different style would be preferable in a new codebase.
- If unrelated dead code or design debt is noticed, mention it instead of removing it.

When your changes create orphans:

- Remove imports, variables, functions, tests, files, and docs made unused by your own change.
- Do not remove pre-existing dead code unless the task explicitly includes that cleanup.

Every changed line should trace directly to the user's request, the acceptance gate, or cleanup caused by the change.

## Closed Verification Loop

Transform tasks into verifiable goals and loop until verified.

Examples:

- "Add validation" means write checks for invalid inputs, then make them pass.
- "Fix the bug" means reproduce the bug with a focused test or scenario, then make it pass.
- "Refactor X" means establish passing behavior before the refactor, change it, then verify behavior still passes.

For multi-step tasks, plans should include the verification command or gate for each step:

```text
1. [Step] -> verify: [check]
2. [Step] -> verify: [check]
3. [Step] -> verify: [check]
```

Unit TDD is the implementer-internal loop. A feature or component is not complete until the relevant acceptance or contract gate passes and progress/memory state is updated.

## Feature and Component Gates

Feature gates should verify user-visible or system-visible behavior, such as:

- an e2e/user-flow check
- an API scenario
- a CLI scenario
- a project-specific integration harness

Component gates should verify the boundary that other agents or neighboring systems depend on, such as:

- DTO or data-contract shape
- schema validation
- adapter request/response payloads
- domain command/result types
- public API behavior and error cases

Prefer the smallest automated gate that gives real confidence. Do not mark a feature or component complete based only on implementation notes or unverified assumptions.

## Clean Handoff

Before ending a session, compacting, or dispatching follow-on agents:

- Make sure the working tree state is intentional.
- Run the relevant focused tests and feature/component gates.
- Commit coherent completed slices when appropriate.
- Update FRD progress and Cutiepie memory.
- Record caveats, known gaps, and failed approaches where future agents will see them.
- Ensure the next agent can identify the next unfinished feature and the contracts it must preserve.

These guidelines are working when diffs are smaller, assumptions are clearer, subagent handoffs need less repair, and completion claims are backed by tests, gates, commits, and memory updates.
