---
name: subagent-driven-spec-development
description: Use when implementing Gummy story specs with subagents, contracts, TDD, and acceptance-check verification.
---

# Subagent-Driven Spec Development

Implement specs from `.gummy/plans/story_*/specs/`.

## Workflow

1. Run `scripts/check-gummy-state.sh .`.
2. Read PRD, architecture, config, story ADR, contracts, and specs.
3. Select incomplete specs with complete dependencies.
4. Use `multi-agent-adapter`.
5. Dispatch parallel workers only for specs listed in compatible contract parallel groups and with non-overlapping file scopes.
6. Require each worker to use TDD and run acceptance checks.
7. Parent session validates contracts and integration.
8. Update acceptance checks and `completed` flags only after evidence passes.
9. Run documentation, cleanup, and update-state.
