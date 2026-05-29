---
name: devils-advocate
description: Use when a story plan, spec, contract, ADR decision, implementation approach, or completion claim needs adversarial review.
---

# Devils Advocate

Use one independent reviewer through `multi-agent-adapter`. Default to review-only.

## Review Packet

Include only what is needed:

- user goal and constraints
- relevant PRD story
- story plan, ADR, specs, and contracts
- current diff or completion claim
- settings/configuration and verification gates

Ask for hidden assumptions, simpler alternatives, boundary risks, missing contracts, verification gaps, and documentation cleanup needed.

The parent agent makes the final decision and updates affected story docs when direction changes.
