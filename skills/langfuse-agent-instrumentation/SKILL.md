---
name: langfuse-agent-instrumentation
description: Reusable, project-agnostic Langfuse instrumentation conventions for LLM-agent applications. Use when adding or modifying Langfuse spans/observations, scores, or Managed Evaluator wiring in any agentic codebase (ReAct loops, tool-using agents, RAG pipelines). Covers setting observation `as_type` explicitly per event kind, the input/output/metadata discipline so Managed Evaluators can bind their template variables, agent-name vs factory-key separation, per-generation cost tagging, the client-side-vs-managed scorer split, and verify-before-asserting. A project-agnostic supplement to the official `langfuse` skill.
---

# langfuse-agent-instrumentation

Conventions for instrumenting an LLM agent with Langfuse so every trace is correctly **typed** and carries the **fields evaluators need to score it**. Distilled from two production failure patterns that fail *silently*:

1. Every observation left at the default `as_type="span"` (the "everything-is-a-span" bug) — traces become an untyped blob that the UI can't group and evaluators can't target.
2. Empty `input` / `output` / `metadata` on observations — evaluator template variables bind to nothing, so the evaluator short-circuits to a misleading fallback score (often `1.0` or `0.0`) instead of erroring.

Neither throws. Both quietly corrupt your metrics. These conventions prevent them.

## Relationship to the official `langfuse` skill

This **supplements** the official `langfuse` skill (generic CLI usage, docs retrieval, prompt management, SDK upgrades).

- Generic Langfuse questions (API shape, CLI flags, prompt management) → consult the official `langfuse` skill first.
- Anything you **instrument** → apply the conventions below *on top*; they take precedence over generic defaults.

Keep both active when writing instrumentation code.

## Convention 1 — set observation `as_type` explicitly (never default to `span`)

Langfuse's typed observations (`agent` / `retriever` / `tool` / `generation` / `guardrail` / `chain` / `span` / `event` / …) drive UI grouping **and** what evaluators can target. Map by **event kind**, not by convenience:

| Event / instrumentation point | `as_type` | Why |
|---|---|---|
| Root observation for one agent run (`agent.run()` / `query()`) | `agent` | the agent IS the unit of work |
| Retrieval **by query** (vector / hybrid / keyword search, chunk reads) | `retriever` | canonical retrieval semantics; evaluators target retrievers |
| Lookup / action tools (fetch-by-id, function/API call, code execution) | `tool` | a tool call, not retrieval-by-query |
| Guardrail / policy / hook decisions (denied tool call, RBAC check, budget gate) | `guardrail` | protective gating |
| Any LLM call (executor turn, planner, verifier, summariser, judge) | `generation` | a model generation; carries usage/cost |
| A skill / sub-routine = an ordered sequence of steps | `chain` | procedural chain |
| Genuinely uncategorised | `span` | fallback only — don't reach for it lazily |

**Centralise the mapping in ONE function** (e.g. `observation_type_for(event)`), keyed off your event-kind enum. Adding a new tool or event kind = one edit there + extend the enum — never scatter `as_type` literals across call sites.

## Convention 2 — every observation MUST populate `input`, `output`, `metadata`

Managed Evaluators bind their template variables (`{{question}}`, `{{answer}}`, `{{context}}`, …) to trace/observation **fields**. Empty fields → empty bindings → silent fallback score. Populate them deliberately:

| Observation | `input` | `output` | `metadata` |
|---|---|---|---|
| Agent root | `{"question": …}` | `{"answer": …}` | run/pipeline version, `cost`, `tokens`, **`retrieval_context: list[str]`** (the retrieved passages — required by faithfulness/groundedness evaluators), category/tags, `session_id` |
| Retriever / tool | the tool's input args | the **full** tool result (not a truncated preview) | `latency_ms`, `tool_name`, `result_count` |
| Generation | the message list (`[{role, content}, …]`) | the completion text | `model` (exact deployment string), `usage_details: {input, output, cache_read, cache_write}`, `cost_details: {total_cost}` |
| Guardrail | what was attempted (tool + args) | `{reason: …}` | `hook_name`, `latency_ms` |

**The field teams forget: `metadata.retrieval_context` on the root** — a `list[str]` of the retrieved passages. Faithfulness, context-precision, and context-recall evaluators bind their `contexts` variable to it; without it they cannot score grounding. Set it via your client's trace-update call once retrieval is done.

**Discipline rule — before adding ANY observation, answer two questions:**
1. What `as_type` is it? (Convention 1)
2. Which evaluator might score it, and what does it bind to — so populate `input`/`output`/`metadata` to make that binding work.

## Convention 3 — keep the agent's name distinct from its factory/registry key

An agent's **class / display name** (what appears in traces and code) and its **factory / registry key** (how it's selected via config or CLI) serve different purposes — keep them decoupled.

- The root observation's display name should identify the agent + the unit of work, e.g. `<AgentName>/<request_id>`.
- The factory key is internal plumbing (`@register("...")`, `--backend ...`); a rename of one should not force churn of the other.
- Never resurrect a legacy class name in new code — pick the canonical name and stamp it consistently onto traces (`metadata.pipeline_version`, span name).

## Convention 4 — tag every generation with its real model (so cost is correct)

On each `generation` observation, set `metadata.model` (plus `usage_details` / `cost_details`) to the **actual deployment/model string** used — Langfuse computes server-side cost from it. A wrong or missing model string bills the generation at the wrong rate (or zero), and per-step cost becomes meaningless.

Route reasoning-heavy steps (planning, verification, the agent loop) to a stronger model and mechanical steps (claim comparison, classification judges) to a cheaper tier — and **tag each accordingly** so the cost split is visible per step.

## Convention 5 — split scorers: client-side vs Managed Evaluators

| Scorer kind | Where it runs |
|---|---|
| Deterministic metrics (id-overlap recall/precision, exact-match, refusal detection) | **client-side** → `langfuse.score(trace_id, name, value)` |
| Structural judges that must walk the span/trace DAG (trajectory, tool-sequence) | **client-side** (Managed Evaluators don't surface the DAG) |
| Single-shot LLM-as-judge (answer correctness, faithfulness, context precision) | **Managed Evaluators (server-side)**, configured in the Langfuse UI, binding to trace fields |

Don't hand-roll new single-shot LLM judges in code — add them as Managed Evaluators so they're **config, not deploys**. Discover what your workspace already has before authoring one:

```bash
npx langfuse-cli api unstable-evaluators list
```

(The Ragas agentic suite — context precision/recall, answer correctness, goal accuracy, topic adherence — is usually already available server-side. A "Ragas" maintainer tag means server-side Ragas-authored, NOT a client-side dependency.)

## Convention 6 — verify before asserting instrumentation state

Don't claim instrumentation facts from memory:

- "this observation has `as_type=X`" → grep the observation-creation call site and confirm.
- "Managed Evaluator Y is configured" → check the Langfuse UI / CLI; don't assume.
- "we set field Z on the trace" → grep for the setter before trusting it.

## When this skill applies

Auto-trigger when the work touches:

- New or modified Langfuse observations / spans / traces in an agent codebase
- Choosing an `as_type` for an event
- Score emission (deterministic metrics OR LLM-as-judge)
- Managed Evaluator configuration / selection
- Tagging generation cost / model
- Debugging an evaluator that scores `0`/`1` unexpectedly (almost always an empty bound field)
- Tracing the agent loop, tool calls, guardrails/hooks, or sub-skills

## Adapting this skill to a specific project

Fork this into a project-local `*-langfuse-conventions` skill and append:
- Your concrete event-kind → `as_type` mapping (real tool names) + where it's centralised (the `observation_type_for` function + the event-kind enum).
- Your exact root-trace metadata schema (the field names your evaluators bind to).
- Your model-routing table (which model each tier uses) and the cost/pricing source of truth.
- Your workspace's Managed Evaluator catalog and the client-side scorers you keep in code.
Keep the project file's conventions taking precedence over both this skill and the upstream defaults.
