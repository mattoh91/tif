---
name: research-enrichment
description: Use after feature_list.json exists when feature requirements should be enriched with research citations from papers, AI lab articles, docs, or major GitHub repos.
---

# Research Enrichment

Enrich `.cutiepie/docs/feature_list.json` with references and requirement suggestions.

## Source Priority

1. Recent arXiv papers or primary research papers.
2. Articles, docs, or engineering posts from major AI companies and AI labs such as OpenAI, Anthropic, Google, DeepMind, Meta, Microsoft, and similar primary sources.
3. Popular, relevant GitHub repos with active maintenance and concrete implementation patterns.
4. User-provided/local docs when web access is unavailable.

## Workflow

1. Read `PRD.md` and `feature_list.json`.
2. Identify research questions per feature group.
3. Use parallel research subagents when the host supports them; otherwise research serially and keep citations precise.
4. Add references to existing features or propose new features only when evidence supports them.
5. Do not mark features as passing.
6. Record uncertain or rejected suggestions in `ARD.md` only if they affect a decision.

## Output

- Updated `feature_list.json` references and, when warranted, added feature specs with `passes: false`.
- Short summary of sources and why they matter.
