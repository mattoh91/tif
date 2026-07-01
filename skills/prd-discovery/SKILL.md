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
---
```

Use `project-intake` first when these fields are unknown.

## Required Sections

- Problem Statement
- Stories table with stable `story_<nnn>` IDs
- Acceptance Notes for each story
- Non-Goals

After the user approves PRD stories, use `story-planner`.
