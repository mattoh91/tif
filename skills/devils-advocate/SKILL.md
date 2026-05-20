---
name: devils-advocate
description: Use when a plan, spec, architecture decision, implementation approach, or completion claim needs adversarial review, alternative viewpoints, risk surfacing, or a skeptical second lens before execution or merge.
---

# Devils Advocate

Use this skill to get one independent adversarial review through the host's subagent mechanism. The parent agent remains responsible for the final decision.

Default to review-only. Do not let the subagent edit files unless the user explicitly asks for an implementation pass.

## Review Packet

Send the subagent only the context needed to critique the decision:

- user goal and stated constraints
- current plan, spec, architecture note, diff, or completion claim
- active Cutiepie docs from top-level `.cutiepie/` or `docs/cutiepie/`
- relevant component boundaries, DTO/data contracts, settings owner, and verification gates
- recent failures, caveats, and unresolved questions

Do not treat dated archives under `docs/cutiepie/specs/`, `docs/cutiepie/plans/`, or `docs/plans/` as active requirements unless the user explicitly promoted them.

## Workflow

1. State the decision or plan being challenged.
2. Spawn one fresh subagent as an adversarial reviewer.
3. Ask for the strongest plausible objections, not cosmetic nitpicks.
4. Compare the critique against the user goal, active docs, implementation cost, and verification surface.
5. Decide whether to revise the plan, ask the user, proceed unchanged, or reject the critique.
6. If direction changes, update the affected Cutiepie docs, memory, progress tracking, and gates.

## Subagent Prompt

Use this prompt shape:

```text
You are an adversarial SWE reviewer. Your job is to challenge the proposed plan or decision before execution.

Review packet:
[insert concise packet]

Focus on:
- hidden assumptions
- simpler alternatives
- overengineering or underengineering
- component boundary and DTO/data-shape risks
- settings/configuration drift
- missing feature or component verification gates
- stale-doc, memory, or progress-tracking risks
- likely failure modes during multi-agent development

Do not rewrite the plan from scratch unless the current direction is materially wrong.
Do not make file edits.

Return:
1. Strongest objection
2. Best alternative
3. Boundary or DTO/data-contract risks
4. Verification gaps
5. Documentation or memory updates needed
6. Recommendation: proceed, revise, ask user, or stop
```

## Chair Decision

After the subagent responds, synthesize the result in the parent thread:

- what you accept
- what you reject and why
- concrete changes to make before proceeding
- remaining risk after the decision

Do not blindly follow the adversarial answer. The purpose is better judgment, not automatic veto.
