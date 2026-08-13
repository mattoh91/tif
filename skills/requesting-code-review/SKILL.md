---
name: requesting-code-review
description: Use after implementing a story spec or before merge to review work against specs, contracts, tests, and acceptance checks.
---

# Requesting Code Review

Dispatch a reviewer through `multi-agent-adapter`.

Give the reviewer **wider context than the builder had** — that widened view is
where a reviewer's advantage comes from. Builders search for something that works
and stop when it does; reviewers hunt for the input that breaks it. A reviewer
handed only the builder's brief re-approves the builder's blind spots.

## Reviewer Packet

Include (a superset of the builder's packet):

- implemented spec path (content whole, not summarized)
- the PRD story row and acceptance notes the spec was distilled from (verbatim)
- story plan and ADR
- contracts.json excerpt
- changed files
- tests run
- acceptance checks run
- base/head diff range when available

Ask the reviewer to verify:

- implementation satisfies the **PRD story's acceptance notes**, not just the
  spec distilled from them — the spec may have silently dropped a requirement
- contracts were honored
- acceptance checks were actually run before `passes: true`
- `completed: true` is justified
- at least one deliberate attempt to break it: twin records competing for the
  same slot, denied permissions, boundary counts, empty sets — not a re-run of
  the builder's green tests, which encode the builder's understanding
- user-facing text is treated like an API: every option, offer, or claim it
  makes traces to a code path that actually honors it
- no unrelated scope was added
- docs/config/ADR updates are sufficient

For `full`-weight stories, use `devils-advocate` as the review lens.

Fix critical and important issues before continuing.
