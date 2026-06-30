---
name: progress-planner
description: Compatibility skill; use story-planner to update story-local ADR/spec workflow state.
---

# Progress Planner

Gummy progress is story-local.

- Story decisions and workflow rationale live in `.gummy/plans/story_*/ADR.md`.
- Spec dependencies and completion live in each spec frontmatter.
- Acceptance result state lives in each spec's `acceptance_checks`.
- Safe parallel groups live in `contracts.json`.

Use `story-planner` for planning updates and `cleanup` for end-session state hygiene.
