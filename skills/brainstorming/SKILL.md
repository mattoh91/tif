---
name: brainstorming
description: Use when the user starts with an idea or asks what to build; routes Gummy planning through project intake, PRD stories, story specs, contract design, and approval.
---

# Brainstorming Ideas Into Story Specs

Do not implement code until the user approves the PRD stories, story specs, and contracts, unless the user explicitly asks to bypass planning.

## Workflow

1. Use `project-intake` when project context is missing or stale.
2. Use `prd-discovery` to write or update `.gummy/docs/PRD.md` with stories.
3. Use `story-planner` to create one `.gummy/plans/story_<nnn>_<slug>/` folder per story.
4. Draft story specs with `completed: false` and acceptance checks with `passes: false`.
5. Use `research-enrichment` inside specs when libraries, modules, tools, ML algorithms, vector stores, databases, or frameworks affect implementation choices.
6. Use `contract-designer` after specs are drafted.
7. Run `scripts/check-gummy-state.sh .`.
8. Ask the user to approve the story plans/specs/contracts before `/build`.

## Requirements

- Specs must be subagent-ready: owned files, dependencies, contracts, inputs/outputs, TDD unit-test plan, and natural-language integration/e2e outcome.
- Story `ADR.md` records tool/library decisions, algorithms, design patterns, and tradeoffs.
- Brownfield projects must include repo review and architecture baseline before planning.
- Heineken projects must include Brewery/Atlassian setup considerations and Confluence documentation intent.
