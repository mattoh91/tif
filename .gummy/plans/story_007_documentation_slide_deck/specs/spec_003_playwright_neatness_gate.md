---
story_id: story_007
spec_id: spec_003
title: Playwright diagram neatness verification gate
completed: false
depends_on:
  - spec_002
contracts:
  provides:
    - gummy.deck.neatness_report
  consumes:
    - gummy.deck.diagram_artifact
acceptance_checks:
  - id: check_001
    category: functional
    description: The gate verifies diagram neatness using embedded XML as ground truth and rendered geometry from the DOM.
    steps:
      - "Step 1: Generate a deck with a deliberately clean diagram."
      - "Step 2: Run the neatness gate and verify it produces a structured report with accepted=true and no failed hard checks."
      - "Step 3: Verify the report's edge checks were derived from the embedded mxGraphModel source/target, not guessed from pixels."
    passes: false
  - id: check_002
    category: functional
    description: Hard-fail defects block deck acceptance.
    steps:
      - "Step 1: Inject an overlapping-shape, off-canvas, and mislanded-arrow defect into a test diagram."
      - "Step 2: Run the neatness gate."
      - "Step 3: Verify each hard check fails, accepted=false, and the deck is reported as not accepted."
    passes: false
  - id: check_003
    category: functional
    description: When Playwright or Node is unavailable, the gate degrades to skipped-and-reported rather than claiming a pass.
    steps:
      - "Step 1: Run deck generation in an environment without a Playwright runtime."
      - "Step 2: Verify the deck still renders and the report has skipped=true with a skipped_reason."
      - "Step 3: Verify the harness never reports the diagram as verified when the gate was skipped."
    passes: false
---

# Playwright Diagram Neatness Verification Gate

## Implementation Notes

The gate loads the rendered deck in Playwright and checks the architecture diagram. Ground truth for intended topology comes from the draw.io SVG's embedded `mxGraphModel` XML (which edge connects which nodes, and node geometry). Rendered geometry is read via DOM bounding boxes (`getBoundingClientRect`) of the SVG elements.

Checks:

| Check | Severity | Method |
| --- | --- | --- |
| Overlapping shapes | fail | Pairwise node bounding-box intersection. |
| Off-canvas / clipped element | fail | Element bounds outside the slide/diagram viewport. |
| Mislanded / dangling arrow | fail | Edge endpoint not on its intended source/target node boundary within tolerance (intent from embedded XML). |
| Excessive edge crossings | warn | Count edge-path intersections; flag above threshold. |
| Label overflow | warn | Text bounds exceed the containing shape bounds. |
| Label-shape / label-label collision | warn | Connector-label bounds intersect a node or another label. |
| Edge through unrelated node | warn | Edge path crosses a node that is not its source or target. |
| Sub-minimum node spacing | warn | Gap between node bounds below a configured minimum. |

A deck is accepted only when no `fail` checks remain; `warn` checks are reported but do not block. Emit the structured `gummy.deck.neatness_report`.

Degradation: if Node/Playwright is unavailable, render the deck, set `skipped=true` with a `skipped_reason`, and never report the diagram as verified (ADR-005).

## Research Findings

Reliable neatness checking depends on the embedded mxGraphModel providing edge `source`/`target` and node geometry (spec_002). Confirm the Playwright MCP/browser runtime available on the host at implementation time; record tolerance and crossing-threshold defaults chosen.

## Design Guidance

Keep tolerances configurable. Prefer topology-driven assertions (XML) over pixel heuristics for anything that decides accept/reject. Warn checks may use heuristics since they do not block.

## TDD Unit-Test Plan

- Geometry helpers (bbox intersection, point-on-boundary within tolerance, segment intersection) get focused unit tests with fixed coordinates.
- A clean fixture diagram yields accepted=true; defect fixtures yield the expected failed checks.
- A simulated missing-runtime path yields skipped=true.

## Integration / E2E Expectation

A clean diagram passes the gate and the deck is accepted; a diagram with overlap/off-canvas/mislanded-arrow defects fails and blocks acceptance; a host without Playwright produces a deck with a skipped, honestly-reported gate.

## Owned Files

- `skills/documentation/SKILL.md`
- `scripts/` (deck neatness verification script)
- `tests/` (neatness gate tests and fixtures)

## Out Of Scope

- Deck content/structure (spec_001).
- Diagram authoring/export (spec_002).
