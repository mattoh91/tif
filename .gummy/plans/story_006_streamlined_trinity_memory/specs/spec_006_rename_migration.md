---
story_id: story_006
spec_id: spec_006
title: Cute rename and namespace migration
completed: true
depends_on:
  - spec_001
  - spec_002
  - spec_005
contracts:
  provides:
    - gummy.rename.migration_plan
  consumes:
    - gummy.artifact_authority.matrix
    - gummy.trinity.workflow
    - gummy.learning.candidate_schema
acceptance_checks:
  - id: check_001
    category: functional
    description: User selects a new brand before namespace changes.
    steps:
      - "Step 1: Present the rename shortlist with CLI prefix, memory path, plugin id, and package-name implications."
      - "Step 2: Record the selected name in story ADR."
      - "Step 3: Verify no code namespace changes occur before approval."
    passes: true
  - id: check_002
    category: functional
    description: Namespace migration updates all public and internal surfaces together.
    steps:
      - "Step 1: Search for Gummy/gummy across manifests, docs, skills, hooks, commands, tests, package metadata, and memory paths."
      - "Step 2: Apply the selected rename with compatibility notes or aliases where needed."
      - "Step 3: Run static JSON, shell, compiler, state, scaffold, adapter, and story-flow tests."
    passes: true
---

# Cute Rename And Namespace Migration

## Implementation Notes

The user selected Gummy. The namespace appears in:

- `.gummy/` active state paths
- `~/.gummy/memory/`
- command descriptions
- skills and skill names
- hooks and scripts
- plugin manifests
- package metadata
- README/install docs
- tests and fixtures
- sync scripts

Migration should happen in one broad slice because partial renames are easy to miss.

## Research Findings

No external research is required before presenting options. Namespace availability can be checked after the user narrows the shortlist.

## Rename Decision

| Surface | New Value |
| --- | --- |
| Brand | Gummy |
| CLI/plugin namespace | `gummy` |
| Active state root | `.gummy/` |
| Durable memory root | `~/.gummy/memory/` |
| Core orientation skill | `using-gummy` |
| State checker | `scripts/check-gummy-state.sh` |

## Design Guidance

Prefer names that are easy to type, not embarrassing in enterprise repos, and unlikely to collide with common package managers or binaries.

## TDD Unit-Test Plan

- Add a rename coverage test that scans known surfaces for old and new namespace expectations.
- Run existing plugin sync, compile, state, scaffold, story-flow, shell syntax, and JSON parse checks.

## Integration / E2E Expectation

After migration, a fresh install should expose the new brand while existing users get a clear compatibility path or migration note.

## Owned Files

- `README.md`
- `docs/INSTALL.md`
- `docs/README.*.md`
- `skills/**`
- `commands/**`
- `hooks/**`
- `scripts/**`
- `tests/**`
- plugin/package manifests

## Out Of Scope

- Publishing renamed packages or marketplace entries before local tests pass.
