---
name: component-functional-testing
description: Use when defining or verifying component-level acceptance gates, functional tests, DTO/data contracts, API scenarios, or automated e2e/user-flow checks for a feature or epic.
---

# Component Functional Testing

Use this skill to define the visible acceptance gate for a component or epic. Unit TDD remains the implementer-internal loop; the component acceptance gate proves the component works at the boundary users or neighboring systems actually depend on.

## Acceptable Gate Forms

Choose the smallest automated gate that proves the FRD epic:

1. **DTO/data-contract boundary check**
   - Use for backend, data, agentic, integration, RAG, ETL, service, and domain-boundary work.
   - Verify the shape, required fields, IDs, anchors, metadata, status values, and error cases crossing the system/domain boundary.
   - Include realistic sample input/output where possible.

2. **API or scenario test**
   - Use when behavior spans multiple functions/modules but does not need a browser.
   - Execute a realistic workflow through public APIs, CLI commands, job runners, or service adapters.

3. **Automated e2e/user-flow check**
   - Use when frontend or human workflow behavior matters.
   - Prefer Playwright, browser automation, computer-use tooling, or the project's established e2e harness.
   - Express the natural-language journey and bind it to automated assertions.

## Gate Requirements

Every component acceptance gate must state:

- FRD epic/component ID
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

Then run the component acceptance gate before marking the FRD epic complete. If the gate fails, return to TDD or debugging until it passes.

## Review Standard

A component is not complete until:

- focused tests pass
- the component acceptance gate runs successfully
- the gate matches the FRD epic
- `.sweet/FRD.md` or `docs/sweet/FRD.md` progress is updated
- meaningful deviations are recorded in memory or caveats
