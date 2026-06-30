---
story_id: story_007
spec_id: spec_001
title: Opt-in slide-deck output mode for documentation
completed: true
depends_on: []
contracts:
  provides:
    - gummy.deck.output_spec
  consumes: []
acceptance_checks:
  - id: check_001
    category: functional
    description: The deck is generated only via the dedicated /deck command, and never on a default closeout.
    steps:
      - "Step 1: Run /finish and /document on a sample project."
      - "Step 2: Verify no docs/ppt/ artifacts are produced and the canonical markdown documentation is unchanged in behavior."
      - "Step 3: Run /deck and verify docs/ppt/deck.html is produced."
    passes: true
  - id: check_002
    category: functional
    description: The rendered deck contains the required value-oriented sections sourced from gummy artifacts.
    steps:
      - "Step 1: Generate a deck for a project with PRD, ARCHI, ADR, contracts, and specs present."
      - "Step 2: Verify the deck includes a narrative of what the app does, a measurable-value section, and a per-component breakdown with the research behind each part."
      - "Step 3: Verify each section's content traces back to a .gummy/ source artifact."
    passes: true
  - id: check_003
    category: style
    description: The deck is styled via ui-ux-pro-max and is self-contained.
    steps:
      - "Step 1: Open docs/ppt/deck.html from a clean checkout with no network."
      - "Step 2: Verify styling renders without external CSS/JS fetches and the embedded architecture SVG is visible."
      - "Step 3: Verify the deck theme/layout was produced through ui-ux-pro-max guidance."
    passes: true
---

# Opt-In Slide-Deck Output Mode

## Implementation Notes

Extend `skills/documentation/SKILL.md` with a deck output mode, invoked through a dedicated `/deck` command. The command is the only deck trigger; `/document` and `/finish` never generate a deck on their own (default off).

Deck section structure, sourced from existing gummy artifacts:

| Section | Source | Purpose |
| --- | --- | --- |
| Title / one-liner | `PRD.md` problem statement | What this is. |
| What the app does | `PRD.md` stories, `ARCHI.md` | Narrative overview. |
| Measurable value | `PRD.md` success criteria + story acceptance notes | How it creates value, quantified where possible. |
| Architecture | embedded draw.io SVG (spec_002) | Verified dataflow/component diagram. |
| Component breakdown | per-story `ADR.md`, specs, `contracts.json` | Each component and the research that drove it. |
| Setup / status / next steps | `CONFIG.md`, spec completion flags | Current state. |

Output to `docs/ppt/` as `deck.html`. Treat `docs/ppt/` as derived output regenerable from `.gummy/` inputs.

## Research Findings

No external research required for the content mapping; inputs are gummy's own artifacts. Styling is delegated to `ui-ux-pro-max`.

## Design Guidance

Keep the deck a render of existing content. Do not introduce a new content source or duplicate PRD/ADR/spec text as authored prose; pull from the artifacts. Use the host-agnostic ask pattern (via `multi-agent-adapter`) if any user choice is needed (e.g. theme, audience), never a host-specific question tool.

## TDD Unit-Test Plan

- A test confirms that `/document` and `/finish` produce no `docs/ppt/` output.
- A test confirms that `/deck` produces `docs/ppt/deck.html`.
- A test confirms the generated deck includes the required section ids.

## Integration / E2E Expectation

On a sample project, `/deck` produces a self-contained `docs/ppt/deck.html` with narrative, measurable-value, architecture, and per-component-with-research sections, each traceable to a `.gummy/` artifact.

## Owned Files

- `skills/documentation/SKILL.md`
- `commands/deck.md`
- `commands/finish.md`

## Out Of Scope

- Diagram authoring and embedding (spec_002).
- Diagram neatness verification (spec_003).
