---
story_id: story_007
spec_id: spec_002
title: Hand-authored draw.io architecture diagram pipeline
completed: true
depends_on:
  - spec_001
contracts:
  provides:
    - tif.deck.diagram_artifact
  consumes:
    - tif.deck.output_spec
acceptance_checks:
  - id: check_001
    category: functional
    description: A draw.io architecture diagram is authored from ARCHI.md and exported to SVG with embedded XML.
    steps:
      - "Step 1: Generate a deck for a project whose ARCHI.md describes a dataflow/component architecture."
      - "Step 2: Verify docs/ppt/architecture.drawio and docs/ppt/architecture.svg exist."
      - "Step 3: Verify the exported SVG contains the embedded mxGraphModel XML (node geometry and edge source/target)."
    passes: true
  - id: check_002
    category: functional
    description: The exported SVG is inlined into the deck and the deck stays self-contained.
    steps:
      - "Step 1: Open docs/ppt/deck.html with no network access."
      - "Step 2: Verify the architecture diagram renders inline (no external image or script fetch)."
      - "Step 3: Verify diagram nodes/edges in the artifact match the components named in ARCHI.md."
    passes: true
  - id: check_003
    category: functional
    description: Drift between ARCHI.md and the deck diagram is flagged at closeout.
    steps:
      - "Step 1: Modify ARCHI.md after a deck has been generated."
      - "Step 2: Run /finish."
      - "Step 3: Verify the harness reports that the deck diagram is stale relative to ARCHI.md and must be regenerated."
    passes: true
---

# Hand-Authored draw.io Architecture Diagram Pipeline

## Implementation Notes

The deck's architecture diagram is hand-authored draw.io, chosen over Mermaid because Mermaid's auto-layout edge routing cannot meet a presentation bar (ADR-002).

Pipeline:

1. Read `ARCHI.md` as the canonical architecture source.
2. Author/update a draw.io diagram at `docs/ppt/architecture.drawio` reflecting the dataflow/components.
3. Export to `docs/ppt/architecture.svg` with the draw.io XML embedded (so topology and geometry travel with the SVG and the diagram stays re-editable).
4. Inline the SVG into the deck (spec_001) so the deck is self-contained and Playwright-measurable.
5. Record drift: store a reference (e.g. ARCHI.md content hash) so `/finish` can flag when ARCHI.md changed but the diagram was not regenerated.

`ARCHI.md` stays the canonical markdown source; the draw.io diagram is a derived presentation artifact.

## Research Findings

draw.io SVG export embeds the `mxGraphModel` XML, which carries node geometry and edge `source`/`target`. This is the ground truth consumed by the neatness gate (spec_003). Confirm embedding is enabled on export (retrieve and record exact export option at implementation time).

## Design Guidance

Do not hand-place coordinates the deck cannot verify: every edge must declare `source` and `target` in the XML so spec_003 can check landing. Keep the node set aligned with ARCHI.md component names to make drift detection meaningful.

## TDD Unit-Test Plan

- A test confirms the exported SVG contains an embedded mxGraphModel with at least the expected node and edge counts.
- A test confirms the drift reference is written and that a changed ARCHI.md is detected as stale.

## Integration / E2E Expectation

Generating a deck produces a draw.io source and an embedded-XML SVG inlined in the deck; changing ARCHI.md afterward causes `/finish` to report the diagram as stale.

## Owned Files

- `skills/documentation/SKILL.md`
- `docs/ppt/architecture.drawio`
- `docs/ppt/architecture.svg`

## Out Of Scope

- Deck section structure and trigger (spec_001).
- Neatness verification logic (spec_003).
