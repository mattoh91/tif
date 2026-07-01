---
name: summon-council
description: Use when a high-impact story plan, spec, contract, architecture choice, or delivery decision needs five independent reviews.
---

# Summon Council

Spawn exactly five independent reviewers through `multi-agent-adapter` when supported. Use inline fallback only when workers are unavailable.

Default roles:

1. Product and requirements reviewer
2. Architecture and component-boundary reviewer
3. Verification and test-strategy reviewer
4. Security, reliability, and failure-mode reviewer
5. Delivery, maintainability, and multi-agent-coordination reviewer

Each reviewer gets the same packet:

- user goal
- relevant PRD story
- story plan, ADR, specs, contracts
- architecture/config context
- diff or proposed decision
- verification gates

The parent agent synthesizes findings and updates affected story docs when direction changes.
