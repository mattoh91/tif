---
name: prd-discovery
description: Use when starting or updating a Tif project; gathers problem statement and stories before story planning.
---

# PRD Discovery

Create or update `.tif/docs/PRD.md`.

## Required Frontmatter

```yaml
---
project_mode: POC
project_context: personal
repo_kind: greenfield
story_dag:          # inter-story dependencies (omit if all stories independent)
  story_002: [story_001]
  story_005: [story_001]
---
```

Use `project-intake` first when these fields are unknown.

## Required Sections

- Problem Statement
- Stories table with stable `story_<nnn>` IDs
- Acceptance Notes for each story
- Non-Goals

## Story Dependency DAG

Whenever you write or update the stories, also emit the machine-readable
`story_dag` block in the frontmatter — this is what lets the harness schedule
stories in parallel instead of nudging through them one at a time (see
`dag-scheduler`). Do not leave dependencies implicit in prose only.

Infer edges from the acceptance notes: if story B consumes, extends, freezes-a-
contract-for, or "clones the pattern" from story A, add `story_B: [story_A]`. A
foundational spike everything builds on is the root. Keep it acyclic; a story
with no upstream simply has no entry (or `[]`). `check-tif-state.sh` validates
that referenced stories exist and the graph is acyclic.

After the user approves PRD stories, use `story-planner`.

## Parked Stories

A story can be designed (ADR, maybe research) before its specs exist. List such
stories in PRD frontmatter `parked_stories: [story_nnn]` — `check-tif-state.sh`
then exempts them from the specs/ADR/contracts structural requirements (present
files are still validated). Remove a story from the list once its specs land.
