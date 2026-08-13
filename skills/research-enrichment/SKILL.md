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
2. **Query the research brain first (when configured).** If `TIF_RESEARCH_BRAIN`
   resolves to a directory, `qmd` is on PATH, and `<dir>/.qmd/` exists, run —
   from the brain dir — `qmd query "<research question>" --format json -n 3`
   before any web search. A relevant hit is recorded as an evidence record with
   `source_type: brain`, the note path, **and the note's own frontmatter
   `source_url` + `date`** (cite through to the primary source, never dead-end at
   the local note). Then do web research only for what the brain did **not**
   cover. If any precondition fails (var unset, no `qmd`, no index), or the query
   exits non-zero / returns no relevant hit, **skip silently** and continue with
   web-first research — no error, no behavior change. See `TIF_RESEARCH_BRAIN` in
   `.tif/docs/CONFIG.md`.
3. Prefer primary docs, official references, major GitHub repositories, arXiv/primary papers, and security advisories.
4. Compare the simplest viable options.
5. Record evidence in the story `ADR.md` or spec body:
   - question
   - sources with URLs and retrieval dates
   - chosen option
   - rejected options
   - security notes
   - verification plan
6. Add concise research notes and implementation guidance to the spec body.
7. **File genuinely-new web evidence back into the brain (when configured).** For
   a source the brain-first query in step 2 did **not** already have, write it
   back so the brain compounds: build an evidence record `{title, source_url,
   date, summary (verbatim, not paraphrased), tags, note_type}` and pass it
   through `research/tools/ingest/enrich_writeback.py` (`write_back`), which
   validates against the frozen write-contract and dedups by canonical url. Then
   re-embed so it is retrievable: `qmd update && qmd embed` in the brain dir.
   Skip when the brain is unconfigured or the evidence was already a brain hit.
8. Update contracts if the choice changes schemas or dependencies.
9. Run `scripts/check-tif-state.sh .`.

Skip external research for trivial or purely local edits only when the ADR/spec records why research is unnecessary.
