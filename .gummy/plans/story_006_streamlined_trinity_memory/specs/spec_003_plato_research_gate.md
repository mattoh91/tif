---
story_id: story_006
spec_id: spec_003
title: Plato research gate
completed: true
depends_on:
  - spec_001
  - spec_002
contracts:
  provides:
    - gummy.research.evidence_record
  consumes:
    - gummy.artifact_authority.matrix
    - gummy.trinity.workflow
    - external.github_and_arxiv.sources
acceptance_checks:
  - id: check_001
    category: functional
    description: Research-dependent specs capture current evidence before design is accepted.
    steps:
      - "Step 1: Select a spec involving a library, framework, database, vector store, model provider, external API, algorithm, or security-sensitive change."
      - "Step 2: Verify /plato records sources, dates, chosen option, rejected options, and security notes in the story ADR/spec."
      - "Step 3: Verify /plato can skip external research for trivial or purely local edits with an explicit note."
    passes: true
  - id: check_002
    category: style
    description: Research notes stay concise and attributable.
    steps:
      - "Step 1: Inspect a generated research note."
      - "Step 2: Verify it prefers primary docs, major repositories, arXiv papers, and security advisories."
      - "Step 3: Verify it avoids dumping long excerpts into active planning docs."
    passes: true
---

# Plato Research Gate

## Implementation Notes

Extend `research-enrichment` and `/plato` so research is not optional when implementation choices materially affect design. Capture an evidence record rather than a long literature review.

Recommended evidence fields:

- `question`
- `sources`
- `source_type`
- `retrieved_on`
- `options_considered`
- `decision`
- `rejected_options`
- `security_notes`
- `contract_impact`
- `verification_plan`

## Research Findings

The user explicitly wants latest web search, GitHub repositories, and arXiv papers to inform solution design. This spec should make that behavior a planning gate for consequential choices.

For this planning pass, the public HERMES Agent repository was reviewed as an external reference for agent memory. Its README describes optional memory-backed prerequisite retrieval for reasoning continuity using embeddings and a LangGraph in-memory store. It does not provide Gummy's approval-gated memory/skill promotion loop, so Gummy keeps the scoped retrieval/provenance lesson and adds explicit review gates.

## Design Guidance

Keep the gate proportional. Examples:

- CSS copy tweak: no external research.
- Choosing a vector store: research required.
- Authentication/session change: security research required.
- Nontrivial algorithm/data structure: primary docs or papers required.
- UI workflow with e2e implications: Playwright strategy required.

## TDD Unit-Test Plan

- Static tests confirm research-enrichment mentions GitHub, arXiv, security practices, and evidence records.
- Contract tests verify specs that consume `external.github_and_arxiv.sources` include research body sections.

## Integration / E2E Expectation

Given a spec that asks for a new vector store or auth mechanism, `/plato` should pause implementation until it has recorded current evidence and updated ADR/contracts if schemas change.

## Owned Files

- `skills/research-enrichment/SKILL.md`
- `skills/solution-architect/SKILL.md`
- `skills/story-planner/SKILL.md`
- `commands/plato.md`
- Relevant story specs and ADRs

## Out Of Scope

- Building a crawler or local paper index.
- Replacing user approval with automatic research conclusions.
