---
name: documentation
description: Use near session closeout or story completion to generate local or Heineken Confluence-ready project documentation from PRD, specs, contracts, architecture, research, and decisions.
---

# Documentation

Run this before cleanup and state refresh.

## Inputs

- `.gummy/docs/PRD.md`
- `.gummy/docs/ARCHI.md`
- `.gummy/docs/CONFIG.md`
- `.gummy/docs/REPO_REVIEW.md` when present
- `.gummy/plans/story_*/ADR.md`
- `.gummy/plans/story_*/contracts.json`
- `.gummy/plans/story_*/specs/spec_*.md`
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

## Slide Deck Output Mode (opt-in, `/deck` only)

This mode is triggered only by the `/deck` command. `/finish` and `/document`
never generate a deck. The deck is a derived presentation rendering of the same
inputs; the canonical markdown documentation stays the primary output.

Output directory: `docs/ppt/` (derived, regenerable) — `architecture.drawio`,
`architecture.svg`, `deck.html`.

Steps:

1. Build a deck content model (JSON) by synthesizing from `.gummy/` artifacts.
   The model is `{ title, sections: [...] }`; required section ids:

   | Section id | Content | Source |
   | --- | --- | --- |
   | `overview` | Narrative of what the app does | `PRD.md` stories, `ARCHI.md` |
   | `value` | How it creates measurable value (quantify where possible) | `PRD.md` success criteria + story acceptance notes |
   | `architecture` | The verified architecture diagram (set `svg` to the inlined SVG) | draw.io export (see diagram pipeline) |
   | `components` | Each component and the research that drove it | per-story `ADR.md`, specs, `contracts.json` |

   Add `setup`/`status` sections as useful. Pull from artifacts; do not invent
   prose or duplicate text the artifacts already own.

2. Author/update the architecture diagram in draw.io and export it to SVG with
   the draw.io XML embedded (see ADR-002 / story_007 spec_002). Inline that SVG
   into the `architecture` section's `svg` field. Record an `ARCHI.md` drift
   reference so `/finish` can flag a stale diagram.

3. Render with `node scripts/deck/build-deck.mjs <model.json> docs/ppt/deck.html`.
   The deck is self-contained (inline CSS/SVG, no external fetches). Apply
   `gummy:ui-ux-pro-max` guidance for theme, layout, and typography.

4. Run the neatness gate:
   `node scripts/deck/verify-deck.mjs docs/ppt/deck.html` (story_007 spec_003).
   The gate needs Playwright (`npm i -D playwright && npx playwright install
   chromium`). Accept the deck only when no hard-fail checks remain. If Node or
   Playwright is unavailable, the gate reports `skipped`; never claim the
   diagram is verified when it was skipped.

If a user choice is needed (theme, audience), use the host-agnostic
"discover, then ask the user to choose" pattern via `multi-agent-adapter`, not a
host-specific question tool.
