---
name: implementation-sequencer
description: Use after story specs exist to refine spec dependencies and safe parallel groups in contracts.json.
---

# Implementation Sequencer

Sequencing is now story-local.

1. Read `.tif/plans/story_*/specs/spec_*.md`.
2. Ensure each `depends_on` list is accurate.
3. Update `contracts.json` `parallel_groups` for specs that can run safely together.
4. Confirm specs in the same parallel group do not edit overlapping files or contracts.
5. Run `scripts/check-tif-state.sh .`.
