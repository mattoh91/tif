---
name: requesting-code-review
description: Use after implementing a story spec or before merge to review work against specs, contracts, tests, and acceptance checks.
---

# Requesting Code Review

Dispatch a reviewer through `multi-agent-adapter`.

## Reviewer Packet

Include:

- implemented spec path
- story plan and ADR
- contracts.json excerpt
- changed files
- tests run
- acceptance checks run
- base/head diff range when available

Ask the reviewer to verify:

- implementation satisfies the spec
- contracts were honored
- acceptance checks were actually run before `passes: true`
- `completed: true` is justified
- no unrelated scope was added
- docs/config/ADR updates are sufficient

Fix critical and important issues before continuing.
