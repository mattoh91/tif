# Story 008 ADR

## ADR-001: Weight Lives In Spec Frontmatter; A Story Is Spike Iff All Specs Are

Status: Accepted

Problem:

- Tif needs a per-story weight so ceremony scales with the deliverable, but a story has no dedicated machine-readable metadata file — only ADR.md (prose), contracts.json (schemas), and its specs.

Decision:

- Carry `weight: spike | full` in **spec frontmatter** (the existing machine-readable surface the checker already parses). No new file type.
- A story is `spike` only when **every** spec in it declares `weight: spike`. Absent = `full`, so all existing stories keep their current behavior (backward compatible).

Consequences:

- The state checker reads weight from specs it already parses; zero parser changes.
- A story's weight is unambiguous from its specs alone.

## ADR-002: Spike Weight Relaxes The State Contract

Status: Accepted

Problem:

- The heaviest ceremony for a small story is the mandatory `ADR.md` and `contracts.json`. For a single-spec prove-the-loop slice there are no story-level tradeoffs and no cross-spec schemas to record.

Decision:

- At `spike` weight, `check-tif-state.sh` makes `ADR.md` and `contracts.json` **optional** (skips the `missing` emits). When either file is present it is still validated normally.
- `full` weight is unchanged: both required.

Consequences:

- A spike story can be one spec file and nothing else, yet remain mechanically valid.
- Full-weight stories retain all guardrails (guarded by a regression test).

## ADR-003: Weight Is Auto-Inferred With A One-Line Override, Not Hand-Assigned

Status: Accepted

Problem:

- Requiring the user to set weight on every story is friction; making it fully silent risks under-planning a consequential story.

Decision:

- Infer weight when a story is created (`/socrates`): default `POC → spike`, `MVP → full`; nudge to `spike` for a single spec with no cross-spec contracts and no research triggers (or "prove/spike/validate" language); nudge to `full` when specs share contracts, security/data-loss is in scope, or research is required.
- State the inferred weight in one line; the user overrides only when wrong. A trusted-automation setting may skip the confirm.
- Ponytail is not involved — it governs code minimalism, a different layer than planning weight.

Consequences:

- Zero friction in the common case; a cheap gate before dropping ADR/contracts.
