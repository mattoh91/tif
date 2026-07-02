---
story_id: story_010
spec_id: spec_005
title: Multi-repo awareness — repo_map + un-versioned .tif warning
completed: true
depends_on: []
contracts:
  provides: []
  consumes: []
acceptance_checks:
  - id: check_001
    category: functional
    description: The checker warns (not fails) when .tif/ is not under version control.
    steps:
      - "Step 1: Run check-tif-state.sh on a .tif project whose root is NOT a git repo."
      - "Step 2: Verify a warning reports the planning state is un-versioned, and the overall result is still valid (warning, not failure)."
    passes: true
  - id: check_002
    category: functional
    description: A git-tracked .tif/ produces no such warning, and repo_map is accepted.
    steps:
      - "Step 1: Add a repo_map block to PRD frontmatter and run in a git-tracked repo."
      - "Step 2: Verify no un-versioned warning fires and repo_map does not cause an error."
    passes: true
---

# Multi-Repo Awareness

## Implementation Notes

- Un-versioned warning: in the checker, detect whether `.tif/` is tracked by git — e.g. `git -C <root> rev-parse` fails (no repo) or `git -C <root> ls-files --error-unmatch .tif >/dev/null` fails. If `.tif/` exists but is not tracked, emit a `warning` (does not set failure status).
- `repo_map`: parse optional `repo_map` from PRD frontmatter (sub-repo name → role/path); accept it without error. Optionally warn if a mapped path is absent. Purely additive; absent = single-repo (today's behavior).

## TDD Unit-Test Plan

- Checker: a non-git fixture root warns and still returns valid; a git-tracked fixture with a repo_map block warns not, errors not.

## Integration / E2E Expectation

A container orchestrating sub-repos is legible, and un-versioned planning state is surfaced before it bites.

## Owned Files

- `scripts/check-tif-state.sh`
- `tests/tif-state/test-check-tif-state.sh`
- `skills/using-tif/SKILL.md` (document repo_map)

## Out Of Scope

- Other affordances.
