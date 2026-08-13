---
name: test-driven-development
description: Use when implementing a story spec with focused failing tests before production changes.
---

# Test-Driven Development

Tif uses TDD inside each story spec implementation.

## Loop

1. Read the target spec, story `ADR.md`, and `contracts.json`.
2. Write a focused failing unit or component test for the next behavior.
3. Implement the smallest change.
4. Refactor while tests stay green.
5. Run the spec's acceptance checks.
6. Update acceptance check `passes` flags only after verification.
7. Update `completed` only after all acceptance checks pass.

TDD proves implementation details. Spec acceptance checks prove user/system outcomes.

## Bug Fixes Reproduce First

A suspected bug gets a test that reproduces the failure (red) **before** the fix,
then goes green with the fix. Asserting a bug is gone without first reproducing it
proves nothing — builder-written tests encode the builder's understanding, so a
misunderstood problem yields tests that certify the misunderstanding. The
reproduce-first step is the only point where the test is checked against reality
instead of against the implementation. Cover the spec's named breaking inputs
(twin records, denied permissions, mismatched counts) in the unit-test plan.
