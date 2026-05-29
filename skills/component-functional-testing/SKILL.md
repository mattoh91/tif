---
name: component-functional-testing
description: Use to define or verify spec acceptance checks and component tests for Cutiepie story specs.
---

# Component Functional Testing

Testing evidence is attached to specs.

## Rules

- Each spec must have at least one `acceptance_checks` entry.
- Functional checks prove user/system behavior.
- Style checks prove UI/UX requirements.
- TDD unit tests are described in the spec body and implemented before code.
- Set `acceptance_checks[*].passes: true` only after running the described check.
- Set `completed: true` only after every acceptance check passes.

If checks are too vague to execute, update the spec before implementation.
