# Implementation Plan

> For agentic workers: implement one feature/component slice at a time. Keep unit TDD internal to the implementation loop. Component completion requires the automated component contract gate; feature completion requires the automated feature acceptance gate.
> Each component task must be dispatchable to a fresh subagent without hidden conversation context. Include the owned boundary, allowed files, input/output DTO or data shape, neighbor contracts, settings/config contract, and exact gate commands.

## Goal

Describe the implementation outcome.

## Features

### Feature 1: Name

FRD feature: F1

Automated feature acceptance gate:

- Define the API scenario, Playwright/browser flow, CLI scenario, or equivalent harness automation.

#### Component 1.1: Name

System/module boundary:

- Define the module, package, route, service, adapter, UI surface, or domain boundary this component owns.

Task boundary:

- In scope:
- Out of scope:

Boundary / contract:

- Define the DTOs, schemas, public API, adapter payloads, domain command/result, or UI state boundary.

Input DTO/data shape:

- Fields:
- Required/optional:
- IDs/enums/status values:
- Validation rules:
- Sample input:

Output DTO/data shape:

- Returned fields:
- Side effects/persistence/events:
- Error shape:
- Sample output:

Neighbor contracts to preserve:

- Define public interfaces, schemas, adapters, API endpoints, UI state, or events that must remain compatible.

Automated component contract gate:

- Define the DTO/data-contract check, schema check, adapter payload check, public API behavior check, or equivalent boundary automation.

Settings/config contract:

- Settings owner:
- CONFIG.md entries:
- Tunables used:

Files:

- Create:
- Modify:
- Test:

TDD block:

- [ ] Write the failing unit or focused integration test.
- [ ] Run it and verify it fails for the expected reason.
- [ ] Implement the minimal code.
- [ ] Run the focused test and verify it passes.
- [ ] Run the component contract gate.
- [ ] Run the feature acceptance gate when all components in this feature are integrated.
- [ ] Update `.cutiepie/FRD.md` status and memory notes.
