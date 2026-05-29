---
name: research-enrichment
description: Use when a story spec needs library, module, tool, database, vector store, framework, ML algorithm, or external-service research.
---

# Research Enrichment

Research belongs inside the relevant story spec and story `ADR.md`.

Use this when implementation choices affect simplicity or effectiveness:

- ML algorithms
- vector stores
- databases
- frameworks
- model providers
- third-party APIs
- major libraries/modules/tools

## Workflow

1. Identify the spec(s) whose implementation choice depends on research.
2. Prefer primary docs, papers, official references, and major repos.
3. Compare the simplest viable options.
4. Record the chosen option and rejected options in the story `ADR.md`.
5. Add concise research notes and implementation guidance to the spec body.
6. Update contracts if the choice changes schemas or dependencies.
7. Run `scripts/check-cutiepie-state.sh .`.
