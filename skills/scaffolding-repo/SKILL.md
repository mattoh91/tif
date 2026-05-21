---
name: scaffolding-repo
description: Use when bootstrapping a new repository or adding Cutiepie project structure: init.sh, Makefile targets, CI baseline, .cutiepie/docs planning artifacts, and ~/.cutiepie memory files.
---

# Scaffolding Repo

Use this skill to create a practical baseline for a new or under-structured project.

## Output Contract

Default in-repo artifacts:

- `.cutiepie/docs/PRD.md`
- `.cutiepie/docs/feature_list.json`
- `.cutiepie/docs/ARD.md`
- `.cutiepie/docs/ARCHI.md`
- `.cutiepie/docs/CONFIG.md`
- `.cutiepie/docs/PLAN.md`
- `init.sh`
- `Makefile`
- `.github/workflows/ci.yml`

Do not offer alternate active artifact locations. `.cutiepie/docs/` is canonical. Historical `docs/cutiepie/specs/`, `docs/cutiepie/plans/`, root-level planning files, and old `.cutiepie/*.md` files do not satisfy the active Cutiepie gate unless the user explicitly asks to migrate historical content into `.cutiepie/docs/`.

Out-of-tree memory artifacts:

- `~/.cutiepie/memory/<project-slug>/MEMORY.md`
- `~/.cutiepie/memory/<project-slug>/FAILURES.md`
- `~/.cutiepie/memory/<project-slug>/SESSIONS/`

## Workflow

1. Inspect the repo: list top-level files, package/build files, existing CI, existing docs, and existing scripts.
2. Infer the stack and available commands. Prefer existing package-manager scripts or project-native commands.
3. Create or patch canonical artifacts under `.cutiepie/docs/`.
4. Copy/adapt templates from `skills/scaffolding-repo/template/`.
5. Do not overwrite meaningful existing files. If `Makefile`, `init.sh`, CI, or Cutiepie docs already exist, patch them conservatively or ask before replacing.
6. Create the memory directory under `~/.cutiepie/memory/<project-slug>/`.
7. Run lightweight validation: JSON/YAML syntax where applicable, `bash -n init.sh`, and `make -n` for new Make targets when available.

## Project Slug

Derive `<project-slug>` from the git remote when available:

```bash
git remote get-url origin
```

Normalize host and path into lowercase filesystem-safe text, for example:

- `git@github.com:mattoh91/cutiepie.git` -> `github.com-mattoh91-cutiepie`
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

- `PRD.md`: problem statement, users, user stories, acceptance notes, non-goals
- `feature_list.json`: machine-readable feature specs, steps, citations, implementation phase, and `passes`
- `ARD.md`: architecture decisions with assumptions, caveats, options, and consequences
- `ARCHI.md`: draw.io dataflow diagram plus component/interface table
- `CONFIG.md`: environment variables plus documented hyperparameters and tunables
- `PLAN.md`: human workflow checklist and phase-level progress only; it must not duplicate individual feature pass/fail state

Every generated feature step sequence should be executable or automatable where feasible. Feature specs prove user/system outcomes through API/CLI scenarios, Playwright/browser/computer-use flows, or equivalent project-specific harness automation. Component contract checks are implementation-internal and support the feature steps; feature pass/fail state lives only in `feature_list.json`.

## Tiny Project Waivers

If the project is intentionally tiny or backend-only, `feature_list.json` may include a scope waiver for the `minimum_25_comprehensive_tests` rule. The waiver must name the rule, reason, approval source, and date. Do not hide the waiver in `ARD.md`.
