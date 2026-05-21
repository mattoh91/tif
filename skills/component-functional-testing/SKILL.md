---
name: component-functional-testing
description: Use when defining or verifying feature steps, feature acceptance checks, DTO/data contracts, API scenarios, or automated e2e/user-flow checks.
---

# Component Functional Testing

Use this skill to define evidence that a feature in `.cutiepie/docs/feature_list.json` really passes.

## Tracking Model

- `feature_list.json` is the feature/test source of truth.
- Each feature has prescribed `steps`; these are the visible acceptance check.
- Component/unit TDD supports implementation internally, but does not mark a feature complete.

## Acceptable Step Forms

Choose the smallest executable check that proves the feature:

1. DTO/data-contract checks for backend, data, agentic, RAG, ETL, and service boundaries.
2. API, CLI, job, or service scenarios.
3. Automated e2e/user-flow checks for frontend or human workflow behavior.
4. Visual/style checks only when UI quality is part of the feature; backend-only projects may omit style features.

## Requirements

Every feature check should state:

- feature ID
- boundary or user flow under test
- setup data
- ordered steps starting with `Step N:`
- expected observable result
- failure signal
- command or harness path when available

## Completion Rule

Do not set `passes: true` until the feature's prescribed steps pass. If the steps are too vague to execute, update `feature_list.json` before implementation.
