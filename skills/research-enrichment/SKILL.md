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
2. Prefer primary docs, official references, major GitHub repositories, arXiv/primary papers, and security advisories.
3. Compare the simplest viable options.
4. Record evidence in the story `ADR.md` or spec body:
   - question
   - sources with URLs and retrieval dates
   - chosen option
   - rejected options
   - security notes
   - verification plan
5. Add concise research notes and implementation guidance to the spec body.
6. Update contracts if the choice changes schemas or dependencies.
7. Run `scripts/check-tif-state.sh .`.

Skip external research for trivial or purely local edits only when the ADR/spec records why research is unnecessary.
