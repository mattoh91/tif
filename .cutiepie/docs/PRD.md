# Cutiepie Product Requirements

## Problem Statement

Cutiepie is a personal SWE harness that should turn a user's plain-language build request into story-scoped plans, specs, contracts, implementation, documentation, and cleanup without redundant state files.

The harness should guide agents through one current path:

1. Capture product intent and stories in `PRD.md`.
2. Create one `.cutiepie/plans/story_<nnn>_<slug>/` folder per story.
3. Draft story specs with machine-readable frontmatter and high-level acceptance checks.
4. Design `contracts.json` after specs are drafted.
5. Build incomplete specs with TDD, integration/e2e verification, documentation, cleanup, and state refresh.

## Users

- Primary user: a developer using Claude Code, Codex, Cursor, Copilot, Gemini, or another agent host.
- Secondary user: a fresh agent session or subagent that must resume without hidden conversation context.

## Stories

| ID | Story | Acceptance Notes |
| --- | --- | --- |
| story_001 | As a developer, I want Cutiepie to replace global completion state with story-local plans, specs, contracts, and ADRs. | The state checker validates `.cutiepie/plans/story_*/plan.md`, `ADR.md`, `contracts.json`, and `specs/spec_*.md`; story specs own completion. |
| story_002 | As a developer, I want a new session to detect greenfield/brownfield and personal/Heineken context before planning. | Brownfield projects get repo review and architecture diagrams; Heineken projects get Brewery client and Atlassian/Confluence workflow prompts. |
| story_003 | As a developer, I want story specs to be subagent-ready. | Each spec documents completion state, dependencies, contracts, TDD expectations, and functional/style acceptance checks in frontmatter. |
| story_004 | As a developer, I want contracts designed after specs exist. | `contract-designer` writes `contracts.json`, aligns spec contract references, and validates missing/extra inputs and outputs before build. |
| story_005 | As a developer, I want end-session documentation and cleanup. | The harness updates docs, prepares/publishes Heineken Confluence docs with approval, removes stale state, and refreshes memory/preamble. |

## Success Criteria

- No active Cutiepie instructions point agents to stale planning surfaces outside the current story-folder model.
- `scripts/check-cutiepie-state.sh .` validates story specs, contracts, ADRs, dependencies, and completion flags.
- `SessionStart` injects PRD, story state, active story plans/specs/contracts, architecture, config, and memory.
- `/brainstorm` creates PRD stories and story folders, then runs contract design before implementation approval.
- `/build` scans incomplete specs and implements the next valid story/spec work.
- End-session skills run documentation and cleanup before state refresh.

## Non-Goals

- Maintaining a separate global feature list.
- Maintaining a global implementation plan.
- Preserving old plan/spec document locations.
- Publishing Heineken Confluence pages without explicit user approval.
