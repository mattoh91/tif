---
name: project-intake
description: Use at the start of a new Cutiepie project or fresh repo session to detect greenfield/brownfield and personal/Heineken context before planning.
---

# Project Intake

Run this before PRD/story planning when the repo has not already been classified in `.cutiepie/docs/PRD.md` frontmatter.

## Intake Principle

Detect before asking. Do not ask what the repo, PRD frontmatter, config, git remote, package files, CI, docs, or existing Cutiepie state already answer.

Ask only decision-forcing questions:

- project classification that remains uncertain after inspection
- POC vs MVP starting mode
- whether detected brownfield conventions are binding
- whether Heineken/Brewery/Atlassian setup is desired or approved
- where approved Confluence documentation should land

Ask 1-2 questions at a time. Prefer a concrete default and let the user correct it.

## Detect Repo Shape

Classify the repo:

- `greenfield`: empty repo, README-only repo, or no meaningful app/test/build structure.
- `brownfield`: existing app/library structure, source directories, package/build files, tests, CI, infra, deployment config, or existing docs.

For brownfield projects, do a repo code review before planning:

- top-level structure and stack
- source/test layout
- build, lint, typecheck, test, run, and deploy commands
- auth, app, data, API, UI, worker, ML/RAG, and third-party integration layers
- config/secrets pattern
- language/runtime version and package manager
- framework and route/endpoint conventions
- data models, database access, migrations, and persistence boundaries
- error handling, logging, observability, and feature flag patterns
- formatter, linter, typechecker, and coverage expectations
- reusable utilities, internal modules, and cross-layer contracts
- existing docs and stale-state risks
- risky areas and missing tests

Write the brownfield summary to `.cutiepie/docs/REPO_REVIEW.md` and update `.cutiepie/docs/ARCHI.md` with a high-level dataflow or layer diagram.

After the review, ask only if the answer affects planning:

```text
I found these conventions: <stack/tests/auth/db/docs/etc>.
Should I treat them as binding for this story, or are any up for change?
```

## Detect Project Context

Classify the project:

- `personal`: default when no enterprise signal exists.
- `heineken`: user says it is a Heineken project, or repo/org/path/docs/env naming strongly indicates Heineken/GenAI Lab/Brewery context.

If uncertain, ask one concise question before bootstrapping enterprise-specific pieces.

## Adaptive Question Ladder

Use this sequence when the user starts with a broad project request and the repo lacks current PRD frontmatter.

First turn, after inspection:

```text
I detected this as <greenfield|brownfield> and <personal|Heineken>. Is that right?
```

If project mode is missing:

```text
Should this start in POC or MVP mode? I will default to POC unless you want MVP.
```

If setup scope is unclear:

```text
For this repo, should I enable Cutiepie story/spec/contracts workflow, dev scaffold checks, and Heineken integrations/docs where relevant?
```

Only after Heineken is confirmed:

```text
Which GenAILab Confluence parent page or section should docs land under?
Which Jira project, issue type, labels, or board should Cutiepie use?
Should I bootstrap the Brewery / GenAI Gateway client now?
```

Do not ask all Heineken questions at once when only one integration is needed. If Atlassian MCP can discover Jira or Confluence options, use discovery first, then ask the user to choose among discovered options.

Update `PRD.md` frontmatter:

```yaml
project_mode: POC
project_context: personal
repo_kind: greenfield
```

Use `project_context: heineken` only after user confirmation or strong repo evidence.

## Heineken Setup

For Heineken projects:

1. Bootstrap the Brewery / GenAI Gateway client for Python projects when relevant, using `skills/scaffolding-repo/references/brewery-client.py`.
2. Document `GENAI_API_KEY` in `.cutiepie/docs/CONFIG.md`.
3. Set up or document Atlassian MCP for Jira/Confluence access according to the active host's MCP configuration surface.
4. Ask which Jira project, issue type, labels, or board should be used only when Jira linkage is part of the requested workflow.
5. Ask the user which GenAILab Confluence parent/page should receive project documentation.
6. Do not publish to Confluence without explicit approval.

## Architecture Diagrams

Choose the smallest useful diagram:

- High-level dataflow/layer diagram for most projects.
- C4 L1/L2 when actors, external systems, or deployable containers need clear boundaries.
- Sequence diagram for a few critical flows only.

Prefer draw.io-compatible XML or Mermaid source for durable docs. Use Excalidraw only for informal exploration.

## Handoff

After intake, use `prd-discovery`, then `story-planner`.
