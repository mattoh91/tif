---
name: progress-planner
description: Compatibility skill; use story-planner to update story-local plan.md workflow state.
---

# Progress Planner

Cutiepie progress is story-local.

- Story workflow lives in `.cutiepie/plans/story_*/plan.md`.
- Spec completion lives in each spec frontmatter as `completed: true` or `completed: false`.
- Acceptance result state lives in each spec's `acceptance_checks`.

Use `story-planner` for planning updates and `cleanup` for end-session state hygiene.
