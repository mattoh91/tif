---
name: documentation
description: Use near session closeout or story completion to generate local or Heineken Confluence-ready project documentation from PRD, specs, contracts, architecture, research, and decisions.
---

# Documentation

Run this before cleanup and state refresh.

## Inputs

- `.cutiepie/docs/PRD.md`
- `.cutiepie/docs/ARCHI.md`
- `.cutiepie/docs/CONFIG.md`
- `.cutiepie/docs/REPO_REVIEW.md` when present
- `.cutiepie/plans/story_*/plan.md`
- `.cutiepie/plans/story_*/ADR.md`
- `.cutiepie/plans/story_*/contracts.json`
- `.cutiepie/plans/story_*/specs/spec_*.md`
- recent implementation diff and test results

## Content Structure

Write documentation that starts with:

1. Problem statement.
2. Stories/features.
3. Research that drove the final shape.
4. Architecture overview.
5. Contracts and data schemas.
6. Setup/configuration.
7. Current status and next steps.

## Diagram Guidance

- Use a high-level dataflow or layer diagram by default.
- Add C4 L1/L2 when external actors/services or deployable containers are important.
- Add sequence diagrams for the most important flows only.
- Prefer draw.io-compatible XML or Mermaid source over informal sketches for durable docs.

## Heineken / Confluence

For `project_context: heineken`:

1. Prepare readable HTML documentation suitable for Confluence.
2. Ask the user where under the GenAILab Confluence space/page tree it should land.
3. Ask for explicit approval before publishing.
4. Use Atlassian MCP if available; otherwise report the exact missing MCP/setup step.
5. Include diagrams, stories, specs, contracts, research, setup, and next steps.

Do not publish without approval.

## Output

Report:

- documentation files or Confluence draft target
- diagrams included
- stories/specs covered
- publish status or approval needed
