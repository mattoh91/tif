# Tif

Tif is a personal SWE harness for Claude Code, Codex, Cursor, Copilot, Gemini, and similar agent hosts. It turns a user idea into PRD stories, story-local specs, contracts, implementation, documentation, cleanup, and approval-gated memory refresh.

Tif is intentionally story-scoped. It does not use a separate global feature list or global implementation plan.

## Installation

Full installation steps live in [docs/INSTALL.md](docs/INSTALL.md).

Quick paths:

```bash
# Codex local plugin install
codex plugin marketplace add /absolute/path/to/tif
```

OpenCode:

```json
{ "plugin": ["tif@git+https://github.com/mattoh91/tif.git"] }
```

Claude Code:

```text
/plugin marketplace add /absolute/path/to/tif/.claude-plugin/marketplace.json
/plugin install tif@tif-dev
/reload-plugins
```

For Cursor, Copilot, and other hosts, generate host-native instruction files:

```bash
python3 scripts/tif-compile.py skills --all --output /tmp/tif-skills
```

## Core Contract

Active state lives here:

```text
.tif/docs/
  PRD.md
  ARCHI.md
  CONFIG.md

.tif/plans/story_<nnn>_<slug>/
  ADR.md
  contracts.json
  specs/
    spec_<nnn>_<slug>.md
```

`PRD.md` owns human stories. Each story folder owns its own workflow, decisions, specs, and contracts. Spec frontmatter owns `completed: true/false` and acceptance-check `passes: true/false`.

## Typical Flow

```mermaid
flowchart TD
    A["User: I want to build X"] --> B["/socrates: requirements Q&A"]
    B --> C["PRD stories"]
    C --> D["/plato: research, ADR, specs"]
    D --> E["contracts.json"]
    E --> F["check-tif-state"]
    F --> G{"User approves?"}
    G -->|yes| H["/aristotle"]
    H --> I["TDD per spec"]
    I --> J["acceptance checks + e2e when needed"]
    J --> K["completed flag update"]
    K --> L["/finish"]
    L --> M["docs + cleanup + update-state"]
    M --> N["memory-review"]
```

## Commands

```text
/socrates   requirements Q&A, project intake, PRD stories, unresolved questions
/plato      research-driven design, ADR decisions, specs, contracts, state check
/aristotle  TDD implementation, focused tests, acceptance checks, Playwright/e2e
/finish     documentation, cleanup, update-state, memory candidate review
/memory-review approve/reject staged self-improvement candidates

/onboard     classify greenfield/brownfield and personal/Heineken context (alias: /intake)
/brainstorm  create/update PRD stories, story specs, and contracts
/contracts   design or validate story contracts
/build       implement the next dependency-ready incomplete spec
/review      handle PR/code review feedback
/document    generate local or approved Heineken Confluence docs
/deck        render an opt-in docs/ppt/deck.html slide deck (verified diagram)
/cleanup     remove stale/orphaned state before closeout
/preamble    manual resume context when hooks are unavailable
/update-state refresh memory and preamble
```

The older commands remain useful as expert shortcuts. The philosophical flow is the recommended start-to-finish path.

## Project Intake

Tif detects:

- `greenfield` vs `brownfield`
- `personal` vs `heineken`
- `POC` vs `MVP`

Brownfield projects get repo review and architecture baseline. Heineken projects get Brewery / GenAI Gateway setup when relevant, Atlassian MCP setup guidance, and Confluence documentation flow with explicit user approval before publish.

Intake is adaptive: Tif inspects first, then asks only unresolved decision questions such as POC vs MVP mode, whether brownfield conventions are binding, and which GenAILab/Jira targets to use for confirmed Heineken projects.

`multi-agent-adapter` normalizes Claude Code tasks, Codex workers, and inline fallback so the same story-spec task packet can run across hosts.

## Spec Frontmatter

Every story spec starts with:

```yaml
---
story_id: story_001
spec_id: spec_001
title: Login API
completed: false
depends_on: []
contracts:
  provides:
    - auth.login.response
  consumes: []
acceptance_checks:
  - id: check_001
    category: functional
    description: User can log in and receive an active session.
    steps:
      - "Step 1: Navigate to the login page."
      - "Step 2: Submit valid credentials."
      - "Step 3: Verify the dashboard loads and session is active."
    passes: false
---
```

`completed: true` is allowed only when every acceptance check in the spec has `passes: true`.

## Contracts

`contracts.json` is created after specs are drafted. It aligns providers, consumers, schemas, dependencies, and safe parallel groups.

Run:

```bash
scripts/check-tif-state.sh .
```

The checker validates docs, story folders, specs, dependencies, contract references, and completion flags.

## Memory Review

Hooks and `/finish` may stage learning candidates in `~/.tif/memory/<project-slug>/CANDIDATES.jsonl`. Review them with:

```bash
scripts/tif-memory-review.sh
scripts/tif-memory-review.sh --approve <candidate-id>
scripts/tif-memory-review.sh --reject <candidate-id>
```

Promotion is explicit. Tif should not silently mutate durable memory, skills, docs, or tests.

## Skill Compiler

Compile Tif skills into agent-native formats:

```bash
python3 scripts/tif-compile.py skills --all --output /tmp/tif-skills
```

Outputs:

- Claude/Copilot: `<output>/<skill>/SKILL.md`
- Cursor: `<output>/.cursor/rules/<skill>.md`
- Codex: `<output>/AGENTS.md` with replaceable Tif markers

## Verification

Useful checks:

```bash
node -e "for (const f of ['.agents/plugins/marketplace.json','package.json','.claude-plugin/plugin.json','.claude-plugin/marketplace.json','.codex-plugin/plugin.json','gemini-extension.json','.version-bump.json','hooks/hooks.json']) JSON.parse(require('fs').readFileSync(f,'utf8'))"
bash -n hooks/session-start hooks/pre-compact hooks/session-end hooks/codex-stop hooks/update-state scripts/check-tif-state.sh scripts/check-tif-story-state.sh scripts/sync-to-codex-plugin.sh scripts/tif-memory-review.sh
python3 scripts/tif-compile.py skills --agent codex --output "$(mktemp -d)"
tests/tif-state/test-check-tif-state.sh
tests/scaffolding-repo/test-scaffold-contract.sh
tests/tif-compile/test-tif-compile.sh
tests/multi-agent-adapter/test-multi-agent-adapter-contract.sh
tests/story-flow/test-story-flow-contract.sh
tests/memory-review/test-tif-memory-review.sh
tests/codex-plugin-sync/test-sync-to-codex-plugin.sh
```

Some checks require live agent hosts or authenticated tools. If unavailable, run static validation and document what was skipped.
