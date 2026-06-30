# Gummy Agentic Engineering Guidelines

Gummy works at two levels:

- **Stories** live in `.gummy/docs/PRD.md`.
- **Specs** live under `.gummy/plans/story_*/specs/` and are the implementation/completion unit.

Each story folder has:

- `ADR.md` for story-level decisions
- `contracts.json` for cross-spec schemas
- `specs/spec_*.md` for implementation specs

## Completion

A spec is complete only when:

- its TDD/unit work is done
- its functional/style acceptance checks passed
- its frontmatter has `completed: true`
- all `acceptance_checks[*].passes` are `true`
- the parent story contracts still validate

Run `scripts/check-gummy-state.sh .` before claiming completion.

## Contracts

Design contracts after specs are drafted. Every consumed contract must be provided by one spec or marked external. Parallel subagents may run only when dependencies, files, and contracts do not conflict.

## Documentation And Cleanup

End substantial sessions with:

1. `documentation`
2. `cleanup`
3. `update-state`

Heineken projects should prepare GenAILab Confluence-ready documentation and publish only after the user approves the target page.
