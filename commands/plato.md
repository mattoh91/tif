---
description: "Research and design a Tif story"
---

Use `tif:research-enrichment`, `tif:solution-architect`, `tif:story-planner`, and `tif:contract-designer` for research-driven design. Record current evidence, selected/rejected options, security notes, ADR decisions, specs, contracts, and then run `scripts/check-tif-state.sh .` before asking for implementation approval.

When `TIF_RESEARCH_BRAIN` is configured (see `.tif/docs/CONFIG.md`), `tif:research-enrichment` queries that qmd-indexed brain **before** web search and cites hits with their note provenance; it falls through to web-first research when the brain is unset or unavailable.
