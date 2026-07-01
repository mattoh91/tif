---
name: review
description: Use when PR, branch, ticket, or code review feedback needs to be addressed against Tif story specs.
---

# Review

Use review feedback without scope creep.

## Inputs

- Current branch and git status
- Review comments or PR/ticket source
- `.tif/docs/PRD.md`, `ARCHI.md`, and `CONFIG.md`
- Relevant story `ADR.md`, `contracts.json`, and specs

## Workflow

1. Group comments by concern.
2. Map each concern to a story spec or mark it out of scope.
3. Fix one concern at a time.
4. Run focused tests and affected spec acceptance checks.
5. Update spec frontmatter only when verification passes.
6. Update story ADR/config/contracts only if the review changes decisions or schemas.
7. Run documentation, cleanup, and update-state.

Do not self-approve, merge, or publish external docs without user approval.
