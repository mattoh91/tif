---
name: writing-plans
description: Use when you have a spec or requirements for a multi-step task, before touching code
---

# Writing Plans

## Overview

Write comprehensive implementation plans assuming the engineer has zero context for our codebase and questionable taste. Document everything they need to know: which feature is being advanced, which files to touch for each component, code, testing, docs they might need to check, how to test it, and what state to update. Give them a feature-by-feature plan with component-level contract gates and implementer-internal TDD blocks. DRY. YAGNI. TDD. Frequent commits.

Assume they are a skilled developer, but know almost nothing about our toolset or problem domain. Assume they don't know good test design very well.

**Announce at start:** "I'm using the writing-plans skill to create the implementation plan."

**Context:** This should be run in a dedicated worktree (created by brainstorming skill).

**Save plans to:** `.sweet/PLAN.md` by default, or `docs/sweet/PLAN.md` if the project uses docs-based Sweet artifacts.
- Root-level `PLAN.md` is allowed only when the user explicitly requests root-level planning files.
- User preferences for plan location override this default.

## Scope Check

If the spec covers multiple independent subsystems, it should have been broken into sub-project specs during brainstorming. If it wasn't, suggest breaking this into separate plans — one per subsystem. Each plan should produce working, testable software on its own.

Follow `docs/sweet/AGENTIC_ENGINEERING_GUIDELINES.md` when available. Feature progress, component contracts, git commits, FRD updates, and Sweet memory are the context substrate for subagents and future sessions.

## Required Spec Set Gate

Before writing or updating an implementation plan, verify the full Sweet spec set exists as top-level files in either `.sweet/` or `docs/sweet/`:

- `PRD.md`
- `FRD.md`
- `ARD.md`
- `CAVEATS.md`
- `ARCHI.md`

`PLAN.md` may be missing only when this skill is creating it for the first time. If any required spec file is missing, stop and use `brainstorming` or `scaffolding-repo` to create the missing file before planning. Do not proceed with a partial spec set.

Dated archives such as `docs/sweet/specs/*.md`, `docs/sweet/plans/*.md`, or `docs/plans/*.md` are historical reference only. They do not satisfy this gate unless the user explicitly promotes one into the active `.sweet/` or `docs/sweet/` spec set.

## File Structure

Before defining tasks, map out which files will be created or modified and what each one is responsible for. This is where decomposition decisions get locked in.

- Design units with clear boundaries and well-defined interfaces. Each file should have one clear responsibility.
- You reason best about code you can hold in context at once, and your edits are more reliable when files are focused. Prefer smaller, focused files over large ones that do too much.
- Files that change together should live together. Split by responsibility, not by technical layer.
- In existing codebases, follow established patterns. If the codebase uses large files, don't unilaterally restructure - but if a file you're modifying has grown unwieldy, including a split in the plan is reasonable.

This structure informs the task decomposition. Each task should produce self-contained changes that make sense independently.

## Feature and Component Granularity

Each top-level task should map to one FRD feature/capability. Under that feature, list each component being created or changed. Inside each component block, include TDD step blocks that are bite-sized:

- write the failing focused test
- run it to verify RED
- implement minimal code
- run focused tests to verify GREEN
- refactor while green
- run the automated component contract gate
- update FRD progress and memory/caveats if needed

The visible progress unit is the feature acceptance gate. The implementation ownership unit is the component contract gate. Do not mark a feature complete until the feature gate passes; do not mark a component complete until its contract gate passes.

## Plan Document Header

**Every plan MUST start with this header:**

```markdown
# [Feature Name] Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use sweet:subagent-driven-development (recommended) or sweet:executing-plans to implement this plan feature-by-feature and component-by-component. On hosts that expose unnamespaced skills, use subagent-driven-development or executing-plans. TDD steps are implementer-internal. Component completion requires the automated component contract gate to pass; feature completion requires the feature acceptance gate to pass.

**Goal:** [One sentence describing what this builds]

**Architecture:** [2-3 sentences about approach]

**Tech Stack:** [Key technologies/libraries]

**Spec Set:** [.sweet/PRD.md, .sweet/FRD.md, .sweet/ARD.md, .sweet/CAVEATS.md, .sweet/ARCHI.md or docs/sweet equivalents]

---
```

## Task Structure

````markdown
### Feature N: [Feature / Capability Name]

**FRD Feature:** [F1 / exact FRD section]

**Automated Feature Acceptance Gate:**
- Type: [API scenario | CLI scenario | automated e2e/user-flow | project-specific harness]
- Command: `exact command`
- Test data/scenario: [exact fixture, sample, or user-flow]
- Expected result: [observable pass condition]

#### Component N.M: [Component Name]

**Boundary / Contract:** [DTOs, schemas, public API, adapter payloads, domain command/result, or UI state boundary]

**Automated Component Contract Gate:**
- Type: [DTO/data-contract | schema check | adapter payload | API behavior | automated UI state check | project-specific harness]
- Command: `exact command`
- Test data/scenario: [exact fixture, sample, or user-flow]
- Expected result: [observable pass condition]

**Files:**
- Create: `exact/path/to/file.py`
- Modify: `exact/path/to/existing.py:123-145`
- Test: `tests/exact/path/to/test.py`

- [ ] **TDD Step 1: Write the failing focused test**

```python
def test_specific_behavior():
    result = function(input)
    assert result == expected
```

- [ ] **TDD Step 2: Run test to verify it fails**

Run: `pytest tests/path/test.py::test_name -v`
Expected: FAIL with "function not defined"

- [ ] **TDD Step 3: Write minimal implementation**

```python
def function(input):
    return expected
```

- [ ] **TDD Step 4: Run test to verify it passes**

Run: `pytest tests/path/test.py::test_name -v`
Expected: PASS

- [ ] **Contract Step 5: Run the component contract gate**

Run: `exact command`
Expected: PASS with [observable result]

- [ ] **Feature Step 6: Run the feature acceptance gate when all components in this feature are integrated**

Run: `exact command`
Expected: PASS with [observable result]

- [ ] **Documentation Step 7: Update FRD progress and notes**

Update `.sweet/FRD.md` or `docs/sweet/FRD.md` for this feature and its components. Record meaningful deviations in `.sweet/CAVEATS.md` or memory if applicable.

- [ ] **Commit Step 8: Commit**

```bash
git add tests/path/test.py src/path/file.py
git commit -m "feat: add specific feature"
```
````

## No Placeholders

Every step must contain the actual content an engineer needs. These are **plan failures** — never write them:
- "TBD", "TODO", "implement later", "fill in details"
- "Add appropriate error handling" / "add validation" / "handle edge cases"
- "Write tests for the above" (without actual test code)
- "Similar to Task N" (repeat the code — the engineer may be reading tasks out of order)
- Steps that describe what to do without showing how (code blocks required for code steps)
- References to types, functions, or methods not defined in any task
- Feature tasks without an automated feature gate command
- Component blocks without an automated contract gate command

## Remember
- Exact file paths always
- Complete code in every step — if a step changes code, show the code
- Exact commands with expected output
- DRY, YAGNI, TDD, frequent commits
- Feature acceptance gates for user/system outcomes
- Component contract gates for DTO/data-contract and boundary clarity
- FRD progress and Sweet memory updates after coherent completed slices

## Self-Review

After writing the complete plan, look at the spec with fresh eyes and check the plan against it. This is a checklist you run yourself — not a subagent dispatch.

**1. Spec coverage:** Skim each section/requirement in the Sweet spec set. Can you point to a component task that implements it? List any gaps.

**2. Gate coverage:** Does every feature have a runnable feature acceptance gate? Does every touched component have a runnable contract gate matching the FRD and boundary design?

**3. Placeholder scan:** Search your plan for red flags — any of the patterns from the "No Placeholders" section above. Fix them.

**4. Type consistency:** Do the types, method signatures, and property names you used in later tasks match what you defined in earlier tasks? A function called `clearLayers()` in Component 3 but `clearFullLayers()` in Component 7 is a bug.

If you find issues, fix them inline. No need to re-review — just fix and move on. If you find a spec requirement with no task, add the task.

## Execution Handoff

After saving the plan, offer execution choice:

**"Plan complete and saved to `<path>`. Two execution options:**

**1. Subagent-Driven (recommended)** - I dispatch a fresh subagent per task, review between tasks, fast iteration

**2. Inline Execution** - Execute tasks in this session using executing-plans, batch execution with checkpoints

**Which approach?"**

**If Subagent-Driven chosen:**
- **REQUIRED SUB-SKILL:** Use sweet:subagent-driven-development, or subagent-driven-development on hosts that expose unnamespaced skills
- Fresh subagent per task + two-stage review

**If Inline Execution chosen:**
- **REQUIRED SUB-SKILL:** Use sweet:executing-plans, or executing-plans on hosts that expose unnamespaced skills
- Batch execution with checkpoints for review
