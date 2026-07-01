---
name: writing-plans
description: Compatibility skill; use story-planner to create story-local ADR.md, specs, and contracts under .tif/plans/.
---

# Writing Plans

This skill no longer writes a global implementation plan. Use `story-planner`.

Required flow:

1. Read `.tif/docs/PRD.md`.
2. Create or update the story `ADR.md`.
3. Draft `specs/spec_<nnn>_<slug>.md` files.
4. Use `contract-designer`.
5. Run `scripts/check-tif-state.sh .`.
