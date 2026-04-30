---
name: component-functional-testing
description: Use when defining or verifying feature acceptance gates, component contract gates, functional tests, DTO/data contracts, API scenarios, or automated e2e/user-flow checks for a feature or capability.
---

# Component Functional Testing

Use this skill to define the visible acceptance gate for a feature and the contract gates for components touched by that feature. Unit TDD remains the implementer-internal loop; Sweet gates prove the user/system outcome and the boundaries neighboring systems or agents depend on.

Follow `docs/sweet/AGENTIC_ENGINEERING_GUIDELINES.md` when available. In short: track progress by feature, partition implementation by component, and make DTO/data-contract shapes explicit enough for subagents to work independently.

## Tracking Model

- **Feature acceptance gate:** proves the user-visible or system-visible capability works end to end.
- **Component contract gate:** proves a component boundary is stable: DTOs, schemas, adapter payloads, public API behavior, domain command/result types, and error cases.

Cross-component features normally need both: one feature gate for the integrated outcome, plus component gates for each boundary being added or changed.

## Acceptable Gate Forms

Choose the smallest automated gate that proves the FRD feature or component boundary:

1. **DTO/data-contract component check**
   - Use for backend, data, agentic, integration, RAG, ETL, service, and domain-boundary work.
   - Verify the shape, required fields, IDs, anchors, metadata, status values, and error cases crossing the system/domain boundary.
   - Include realistic sample input/output where possible.

2. **API, CLI, or service scenario**
   - Use when behavior spans multiple functions/modules but does not need a browser.
   - Execute a realistic workflow through public APIs, CLI commands, job runners, or service adapters.

3. **Automated feature e2e/user-flow check**
   - Use when frontend or human workflow behavior matters.
   - Prefer Playwright, browser automation, computer-use tooling, or the project's established e2e harness.
   - Express the natural-language journey and bind it to automated assertions.

## Gate Requirements

Every feature or component gate must state:

- FRD feature/component ID
- gate level: feature acceptance or component contract
- boundary under test
- command to run
- test data or scenario
- expected observable result
- failure signal
- files that implement the gate

The gate may contain multiple checks. Do not force everything into one assertion or one test case if a small scenario suite gives clearer evidence.

## Relationship to TDD

Use unit TDD to build the component:

1. write failing focused test
2. verify RED
3. implement minimal code
4. verify GREEN
5. refactor

Then run the relevant component contract gate before marking the component complete. Run the feature acceptance gate before marking the feature complete. If any gate fails, return to TDD or debugging until it passes.

## Review Standard

A component is not complete until:

- focused tests pass
- the component contract gate runs successfully
- the gate matches the FRD feature/component boundary
- `.sweet/FRD.md` or `docs/sweet/FRD.md` progress is updated
- meaningful deviations are recorded in memory or caveats

A feature is not complete until:

- all touched component contract gates pass
- the feature acceptance gate passes
- the FRD feature status is updated
- durable implementation notes are committed or recorded in Sweet memory
