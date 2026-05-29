---
name: writing-plans
description: Compatibility skill; use story-planner to create story-local plan.md, ADR.md, specs, and contracts under .cutiepie/plans/.
---

# Writing Plans

This skill no longer writes a global implementation plan. Use `story-planner`.

Required flow:

1. Read `.cutiepie/docs/PRD.md`.
2. Create or update `.cutiepie/plans/story_<nnn>_<slug>/plan.md`.
3. Create or update the story `ADR.md`.
4. Draft `specs/spec_<nnn>_<slug>.md` files.
5. Use `contract-designer`.
6. Run `scripts/check-cutiepie-state.sh .`.
