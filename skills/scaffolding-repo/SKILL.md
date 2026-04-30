---
name: scaffolding-repo
description: Use when bootstrapping a new repository or adding Sweet project structure: init.sh, Makefile targets, CI baseline, .sweet/docs planning artifacts, and ~/.sweet memory files.
---

# Scaffolding Repo

Use this skill to create a practical baseline for a new or under-structured project.

## Output Contract

Default in-repo artifacts:

- `.sweet/PRD.md`
- `.sweet/FRD.md`
- `.sweet/ARD.md`
- `.sweet/CAVEATS.md`
- `.sweet/ARCHI.md`
- `.sweet/PLAN.md`
- `init.sh`
- `Makefile`
- `.github/workflows/ci.yml`

If the repo already uses `docs/`, ask whether to place Sweet artifacts under `docs/sweet/` instead. Only put `PRD.md`, `FRD.md`, `ARD.md`, `CAVEATS.md`, `ARCHI.md`, and `PLAN.md` at the project root if the user explicitly wants root-level planning files.

Out-of-tree memory artifacts:

- `~/.sweet/memory/<project-slug>/MEMORY.md`
- `~/.sweet/memory/<project-slug>/FAILURES.md`
- `~/.sweet/memory/<project-slug>/SESSIONS/`

## Workflow

1. Inspect the repo: list top-level files, package/build files, existing CI, existing docs, and existing scripts.
2. Infer the stack and available commands. Prefer existing package-manager scripts or project-native commands.
3. Pick the artifact location: `.sweet/` by default, `docs/sweet/` if that better matches the repo, root only by explicit user choice.
4. Copy/adapt templates from `skills/scaffolding-repo/template/`.
5. Do not overwrite meaningful existing files. If `Makefile`, `init.sh`, CI, or Sweet docs already exist, patch them conservatively or ask before replacing.
6. Create the memory directory under `~/.sweet/memory/<project-slug>/`.
7. Run lightweight validation: JSON/YAML syntax where applicable, `bash -n init.sh`, and `make -n` for new Make targets when available.

## Project Slug

Derive `<project-slug>` from the git remote when available:

```bash
git remote get-url origin
```

Normalize host and path into lowercase filesystem-safe text, for example:

- `git@github.com:mattoh91/sweet.git` -> `github.com-mattoh91-sweet`
- `https://github.com/acme/app.git` -> `github.com-acme-app`

If no remote exists, use the current directory name.

## Make Targets

Use these standard targets when the project supports them:

- `init`: install dependencies and prepare local config
- `fmt`: format code
- `lint`: static linting
- `typecheck`: type checking
- `test`: unit/integration tests
- `smoke`: lowest-cost runnable health check
- `ci`: all checks expected in CI

If a command is unknown, keep the target present but make it fail with a clear message telling the user what project command must be filled in. Do not invent working commands for an unknown stack.

## Planning Artifacts

Initialize planning docs with useful structure, not fake content:

- `PRD.md`: product goal, users, epics, non-goals
- `FRD.md`: feature-to-component mapping, automated feature acceptance gates, component contract gates, and progress
- `ARD.md`: architecture decisions with options and consequences
- `CAVEATS.md`: assumptions, dependencies, constraints, known unknowns
- `ARCHI.md`: Mermaid C4 L1/L2 and sequence diagram placeholders
- `PLAN.md`: feature-by-feature implementation plan with component contract gates and nested TDD blocks

Every generated gate should be automatable where feasible. Feature gates prove user/system outcomes through API/CLI scenarios, Playwright/browser/computer-use flows, or equivalent project-specific harness automation. Component gates prove boundaries through DTO/data-contract checks, schema checks, adapter payload checks, public API behavior, or equivalent contract verification.
