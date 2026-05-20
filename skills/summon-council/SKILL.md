---
name: summon-council
description: Use when a high-impact plan, spec, architecture choice, or delivery decision needs five independent subagent reviews from distinct roles, with the parent agent acting as chair to synthesize tradeoffs and decide.
---

# Summon Council

Use this skill for decisions where one reviewer is not enough. The parent agent is the chair: gather five independent perspectives, evaluate the arguments, and make the final call.

Hard rule: spawn exactly five reviewer subagents, one per role prompt. If five role prompts are not available in the conversation, repository, or task context, stop and ask the user for the missing role prompts before dispatching the council.

Default to review-only. Council members must not edit files unless the user explicitly asks for implementation ownership.

## Role Prompts

Use the five role prompts provided by the user or project. Preserve their intent and keep each role isolated in its own subagent.

If the user wants Cutiepie defaults instead of supplied prompts, use these five roles:

1. Product and requirements reviewer
2. Architecture and component-boundary reviewer
3. Verification and test-strategy reviewer
4. Security, reliability, and failure-mode reviewer
5. Delivery, maintainability, and multi-agent-coordination reviewer

Do not silently substitute defaults when the user said specific role prompts should be used.

## Council Packet

Give each council member the same minimal packet, plus its role prompt:

- user goal and decision to evaluate
- current plan, spec, architecture note, diff, or completion claim
- active Cutiepie docs from top-level `.cutiepie/` or `docs/cutiepie/`
- component/module boundaries and DTO/data contracts
- settings/configuration owner and documented hyperparameters
- relevant tests, gates, failures, caveats, and open questions

Do not treat dated archives under `docs/cutiepie/specs/`, `docs/cutiepie/plans/`, or `docs/plans/` as active requirements unless the user explicitly promoted them.

## Dispatch

Spawn all five subagents in parallel when the host supports it.

- Codex: use `spawn_agent` five times, then collect with `wait_agent`.
- Claude Code: use the available Task/subagent mechanism five times.
- Other harnesses: use the closest available independent subagent mechanism.

Each subagent should receive this instruction:

```text
You are council member [N] acting under this role prompt:
[insert role prompt]

Review packet:
[insert concise packet]

Do not edit files. Do not coordinate with other council members.

Return:
1. Decision: approve, revise, reject, or ask user
2. Highest-severity concern
3. Evidence from the packet
4. Specific change requested
5. Boundary, DTO/data-contract, config, or verification risk
6. Confidence and assumptions
```

If a subagent fails or returns unusable output, retry that member once. Do not claim a full council decision from fewer than five substantive responses unless the user explicitly accepts the degraded review.

## Chair Synthesis

The parent agent evaluates the five responses. Do not average votes. Prefer the argument with the strongest evidence and best fit to the user goal.

Return the chair decision with:

- decision: proceed, revise, ask user, or stop
- accepted findings
- rejected findings and why
- conflicts between council members
- required plan, doc, config, memory, or gate updates
- final execution recommendation

When the decision changes project direction, update the affected Cutiepie docs and memory before execution continues.
