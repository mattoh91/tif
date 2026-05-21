---
name: solution-architect
description: Use after PRD.md and feature_list.json exist to create ARCHI.md and ARD.md from a seasoned solutions-architect and DevOps perspective.
---

# Solution Architect

Design the simplest architecture that satisfies `feature_list.json` while leaving clear room for scale.

## Workflow

1. Read `.cutiepie/docs/PRD.md`, `.cutiepie/docs/feature_list.json`, and `.cutiepie/docs/CONFIG.md` if present.
2. Identify components, data stores, external systems, queues/jobs, auth boundaries, observability, deployment concerns, and failure boundaries.
3. Choose the simplest design that keeps component interfaces explicit.
4. Write `.cutiepie/docs/ARCHI.md` with draw.io XML and a component/interface table.
5. Write or update `.cutiepie/docs/ARD.md` with decisions, assumptions, caveats, options, and consequences.
6. Do not add speculative infrastructure.

## ARCHI.md Requirements

- Include a draw.io dataflow diagram source as XML.
- Include component responsibilities.
- Include input/output interface or DTO shapes for every component boundary.
- Include dependencies that affect implementation sequencing.

## Handoff

After architecture is complete, use `implementation-sequencer`.
