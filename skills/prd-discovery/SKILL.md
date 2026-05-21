---
name: prd-discovery
description: Use when starting a new Cutiepie-managed project or missing PRD.md; gathers problem statement and user stories through Socratic Q&A before feature planning.
---

# PRD Discovery

Create `.cutiepie/docs/PRD.md` from a focused requirements conversation.

## Workflow

1. Inspect current repo context, existing `.cutiepie/docs/`, README, and recent commits.
2. Ask one Socratic question at a time until the problem, users, success criteria, constraints, and non-goals are clear.
3. Capture user stories with stable IDs such as `US001`.
4. Write `.cutiepie/docs/PRD.md`.
5. Run a self-review for ambiguity, missing actors, missing acceptance notes, and unsupported assumptions.
6. Ask the user to approve the PRD before deriving features.

## PRD Required Sections

- Problem Statement
- Users
- User Stories
- Success Criteria
- Non-Goals
- Open Questions

## Handoff

After user approval, use `feature-list-builder` to create `.cutiepie/docs/feature_list.json`.
