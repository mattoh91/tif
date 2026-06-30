# Story 007 ADR

## ADR-001: The Slide Deck Is An Opt-In Output Mode Of `documentation`

Status: Proposed

Problem:

- A polished, stakeholder-facing presentation of what the app does, the value it creates, and the research behind each component is valuable, but most of that content already lives in the `documentation` skill's content structure (problem, stories, research, architecture, contracts, setup, status).
- Adding a second skill for "slides" would duplicate ~80% of that content pipeline and reintroduce the artifact sprawl story_006 just removed.

Decision:

- Extend the existing `documentation` skill with an opt-in slide-deck output mode rather than adding a parallel skill. The deck content/render logic lives in `documentation`; only the entrypoint is separate.
- Expose the deck through a dedicated `/deck` command rather than a flag on `/document`. The command is the opt-in: `/finish` and `/document` never generate a deck on their own.
- The canonical markdown documentation remains the primary output; the deck is a derived presentation rendering of the same inputs.

Consequences:

- Session closeout stays lean; decks are deliberate, occasional artifacts.
- One content owner (`documentation`); the deck is a render target, not a new source of truth.

## ADR-002: Deck Diagrams Are Hand-Authored draw.io, Not Mermaid

Status: Proposed

Problem:

- Mermaid auto-layout produces un-tunable, crossing edge routing that does not meet a presentation bar.
- A deck must look deliberate, which requires control over node placement and connector routing.

Decision:

- The deck's architecture/dataflow diagram is hand-authored in draw.io and exported to SVG with the draw.io XML embedded.
- The exported SVG is inlined into the HTML deck so the deck is self-contained (no external JS, screenshot- and Playwright-friendly).
- `ARCHI.md` remains the canonical, agent-legible markdown architecture source. The draw.io diagram is a derived presentation artifact.
- `/finish` flags when `ARCHI.md` changed but the deck diagram was not regenerated, to control drift between the two representations.

Consequences:

- Presentation quality is high and fully controllable.
- Two diagram representations exist; the drift flag keeps them reconciled instead of silently diverging.

## ADR-003: Deck Artifacts Live In `docs/ppt/`

Status: Proposed

Problem:

- The deck adds a draw.io source, an exported SVG, and an HTML file. These are derived presentation output, not planning state, and must not be confused with `.gummy/` planning artifacts.

Decision:

- Deck artifacts are written to `docs/ppt/` (e.g. `architecture.drawio`, `architecture.svg`, `deck.html`).
- `docs/ppt/` is treated as generated/derived output, regenerable from `.gummy/` inputs.

Consequences:

- Planning state under `.gummy/` stays clean and machine-checkable.
- The deck is a shareable artifact in the repo's human-facing `docs/` tree.

## ADR-004: A Playwright Neatness Gate Verifies The Diagram

Status: Proposed

Problem:

- A hand-authored draw.io diagram can have overlapping shapes, mislanded arrows, overflowing labels, and spaghetti crossings. These defects must be caught before the deck is accepted, not shipped to stakeholders.

Decision:

- A Playwright step loads the rendered deck and verifies diagram neatness using the draw.io exported SVG's embedded `mxGraphModel` XML as ground truth for intended topology (which edge connects which nodes), then measures rendered geometry via DOM bounding boxes.
- Hard-fail checks (block deck acceptance): overlapping shapes, elements off-canvas/clipped, dangling or mislanded arrow heads/tails (endpoint not on its intended source/target boundary within tolerance).
- Warn checks (report, do not block): excessive edge crossings, label overflow beyond its shape, label-shape and label-label collisions, edges routed through unrelated nodes, sub-minimum node spacing.
- The gate emits a structured neatness report; the deck is only accepted when no hard-fail checks remain.

Consequences:

- Diagram quality is verified mechanically rather than by eye.
- The verification is reliable (topology from embedded XML) rather than fuzzy pixel heuristics.

## ADR-005: Styling Via `ui-ux-pro-max`; Cross-Harness And Graceful Degradation

Status: Proposed

Problem:

- The deck should look professional without hand-rolling CSS, and gummy targets multiple agent hosts (Claude Code, Codex, Cursor, Copilot, Gemini) with uneven tool support (Node, Playwright, structured-question tools).

Decision:

- Use the `ui-ux-pro-max` skill for deck theme, layout, and typography.
- Any user prompts during deck generation use gummy's host-agnostic "discover, then ask the user to choose" pattern (as in `project-intake`), routed through `multi-agent-adapter`, rather than binding to a host-specific question tool such as Claude Code's AskUserQuestion.
- When Node or Playwright is unavailable on the host, deck generation degrades: it still renders the HTML and reports that the neatness gate was skipped, never silently claiming verification passed.

Consequences:

- Consistent, low-effort styling.
- The feature respects gummy's cross-harness promise and never reports unverified output as verified.
