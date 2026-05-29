---
name: solution-architect
description: Use after PRD/story context exists to create or update architecture diagrams, repo review, and story ADR decisions.
---

# Solution Architect

Design the simplest architecture that satisfies the PRD stories and story specs.

## Workflow

1. Read `.cutiepie/docs/PRD.md`, `.cutiepie/docs/ARCHI.md`, `.cutiepie/docs/CONFIG.md`, and story folders.
2. For brownfield repos, read or create `.cutiepie/docs/REPO_REVIEW.md`.
3. Update `.cutiepie/docs/ARCHI.md` with a high-level dataflow or layer diagram.
4. Use C4 L1/L2 only when actors, external systems, or deployable containers need clarity.
5. Use sequence diagrams for only the most important flows.
6. Record story-specific decisions in the story `ADR.md`.
7. Ensure contracts and specs reflect the architecture.
