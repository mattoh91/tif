---
project_mode: MVP
project_context: personal
repo_kind: brownfield
---

# Tif Product Requirements

## Problem Statement

Tif is a personal SWE harness that should turn a user's plain-language build request into story-scoped ADRs, specs, contracts, implementation, documentation, and cleanup without redundant state files.

The harness should guide agents through one current path:

1. Capture product intent and stories in `PRD.md`.
2. Create one `.tif/plans/story_<nnn>_<slug>/` folder per story.
3. Draft story specs with machine-readable frontmatter and high-level acceptance checks.
4. Design `contracts.json` after specs are drafted.
5. Build incomplete specs with TDD, integration/e2e verification, documentation, cleanup, and state refresh.

## Users

- Primary user: a developer using Claude Code, Codex, Cursor, Copilot, Gemini, or another agent host.
- Secondary user: a fresh agent session or subagent that must resume without hidden conversation context.

## Stories

| ID | Story | Acceptance Notes |
| --- | --- | --- |
| story_001 | As a developer, I want Tif to replace global completion state with story-local ADRs, specs, and contracts. | The state checker validates `.tif/plans/story_*/ADR.md`, `contracts.json`, and `specs/spec_*.md`; story specs own completion. |
| story_002 | As a developer, I want a new session to detect greenfield/brownfield and personal/Heineken context before planning. | Brownfield projects get repo review and architecture diagrams; Heineken projects get Brewery client and Atlassian/Confluence workflow prompts. |
| story_003 | As a developer, I want story specs to be subagent-ready. | Each spec documents completion state, dependencies, contracts, TDD expectations, and functional/style acceptance checks in frontmatter. |
| story_004 | As a developer, I want contracts designed after specs exist. | `contract-designer` writes `contracts.json`, aligns spec contract references, and validates missing/extra inputs and outputs before build. |
| story_005 | As a developer, I want end-session documentation and cleanup. | The harness updates docs, prepares/publishes Heineken Confluence docs with approval, removes stale state, and refreshes memory/preamble. |
| story_006 | As a developer, I want the harness streamlined around a Socrates, Plato, and Aristotle workflow with approval-gated self-improving memory and a new cute brand. | Redundant planning ownership is reduced, commands and hooks map clearly to requirements, research-driven design, empirical validation, closeout, and memory promotion, and rename options are reviewed before namespace migration. |
| story_007 | As a developer, I want an opt-in slide-deck output from the documentation skill that renders a polished, value-oriented HTML presentation with a verified architecture diagram. | A dedicated `/deck` command produces a `docs/ppt/deck.html` styled with `ui-ux-pro-max`, embedding a hand-authored draw.io architecture SVG; a Playwright neatness gate verifies the diagram before the deck is accepted; the deck stays opt-in (`/finish` and `/document` never generate it) and ARCHI.md remains the canonical markdown source. |
| story_008 | As a developer, I want planning weight to scale with the deliverable so small stories aren't buried in ceremony. | A story-level `weight: spike \| full` field (in spec frontmatter, default `full`); at `spike` weight `check-tif-state.sh` makes `ADR.md` and `contracts.json` optional; weight is auto-inferred from `project_mode` + story shape and stated for one-line override, not hand-assigned. |

## Success Criteria

- No active Tif instructions point agents to stale planning surfaces outside the current story-folder model.
- `scripts/check-tif-state.sh .` validates story specs, contracts, ADRs, dependencies, and completion flags.
- `SessionStart` injects PRD, story state, active story ADRs/specs/contracts, architecture, config, and memory.
- `/brainstorm` creates PRD stories and story folders, then runs contract design before implementation approval.
- `/build` scans incomplete specs and implements the next valid story/spec work.
- End-session skills run documentation and cleanup before state refresh.
- Research-dependent specs record current evidence from primary docs, GitHub repositories, arXiv papers, and security references before implementation choices are accepted.
- Memory self-improvement is staged with provenance, security review, and user approval before it mutates durable memory, skills, tests, or docs.

## Non-Goals

- Maintaining a separate global feature list.
- Maintaining a global implementation plan.
- Preserving old plan/spec document locations.
- Publishing Heineken Confluence pages without explicit user approval.
- Automatically applying self-improvement memories, skill changes, or namespace renames without user review.
