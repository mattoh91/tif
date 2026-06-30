---
name: scaffolding-repo
description: Use when bootstrapping a new or under-structured repo with Gummy docs, story ADRs/specs/contracts, repo review, Brewery client, and baseline commands.
---

# Scaffolding Repo

Gummy adopts the project; the project does not have to contort itself around Gummy.

## Output Contract

Default artifacts:

- `.gummy/docs/PRD.md`
- `.gummy/docs/ARCHI.md`
- `.gummy/docs/CONFIG.md`
- `.gummy/plans/story_001_initial_workflow/ADR.md`
- `.gummy/plans/story_001_initial_workflow/contracts.json`
- `.gummy/plans/story_001_initial_workflow/specs/spec_001_initial_slice.md`
- `init.sh`
- `Makefile`
- `.github/workflows/ci.yml`

Out-of-tree memory:

- `~/.gummy/memory/<project-slug>/MEMORY.md`
- `~/.gummy/memory/<project-slug>/FAILURES.md`
- `~/.gummy/memory/<project-slug>/SESSIONS/`

## Workflow

1. Use `project-intake`.
2. Inspect top-level files, package/build files, source/test layout, docs, CI, and scripts.
3. Classify greenfield vs brownfield.
4. Classify personal vs Heineken; ask only if uncertain after repo and config inspection.
5. Copy/adapt templates from `skills/scaffolding-repo/template/`.
6. For brownfield repos, write `.gummy/docs/REPO_REVIEW.md` and update `.gummy/docs/ARCHI.md`.
7. For Heineken projects, add Brewery client setup when relevant and document Atlassian MCP.
8. Do not overwrite meaningful existing files; patch conservatively.
9. Run `scripts/check-gummy-state.sh .`.

## Brownfield Adoption

For brownfield repos:

- detect language/runtime/package manager
- detect framework, route/endpoint conventions, and package layout
- detect app/data/auth/API/UI/worker/ML/third-party layers
- detect source/test layout
- detect formatter/linter/typechecker/test commands
- detect config/secrets pattern
- detect CI/CD and infra files
- identify stale docs and risky areas
- produce a high-level dataflow or layer diagram

Write findings to `.gummy/docs/REPO_REVIEW.md`.

After the review, ask whether detected conventions should be treated as binding before generating story specs.

## Brewery / GenAI Gateway Client

For Heineken Python projects that call LLMs, or when the user asks for the Brewery client:

- Create `src/<package_name>/models/llmrouter.py` from `references/brewery-client.py`.
- Create or patch `src/<package_name>/models/__init__.py`.
- Create `docs/brewery-client.md` from `references/brewery-client.md`.
- Add dependencies to the project dependency owner when present: `openai`, `anthropic`, and `httpx`.
- Document `GENAI_API_KEY` in `.gummy/docs/CONFIG.md`.

Do not add the client to non-Python projects unless the user explicitly asks.

## Atlassian MCP

For Heineken projects:

- identify the active host's MCP configuration surface
- add or document Atlassian MCP setup for Jira/Confluence access
- record the setup in `.gummy/docs/CONFIG.md`
- ask the user for the GenAILab Confluence target before documentation publish

Do not publish to Confluence without approval.

## Make Targets

Use standard targets when supported: `init`, `fmt`, `lint`, `typecheck`, `test`, `smoke`, and `ci`.

If a command is unknown, keep the target present but make it fail with a clear message telling the user what project command must be filled in.
