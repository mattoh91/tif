---
name: feature-list-builder
description: Use after PRD.md exists to derive or update .cutiepie/docs/feature_list.json as the machine-readable feature source of truth.
---

# Feature List Builder

Derive `.cutiepie/docs/feature_list.json` from `.cutiepie/docs/PRD.md`.

## Ownership

`feature_list.json` is the only artifact that owns individual feature completion. The `passes` field starts as `false` and may be changed to `true` only after the feature's prescribed steps pass.

`PLAN.md` must not duplicate individual feature pass/fail state.

## Required Shape

Use an object with:

- `schema_version`
- `scope.size`
- `scope.waivers`
- `features`

Every feature requires:

- `id`
- `user_story_ids`
- `category`: `functional` or `style`; omit `style` features only for backend-only projects
- `priority`
- `description`
- `steps`
- `references`
- `dependencies`
- `implementation_phase`
- `passes`

All initial features must use `"passes": false`.

## Feature Requirements

- Cover every user story exhaustively.
- Order features by priority, fundamental capabilities first.
- Include both narrow tests with 2-5 steps and comprehensive tests with 10+ steps.
- At least 25 tests must have 10+ steps unless a tiny/backend-only waiver is explicit in `scope.waivers`.
- Every step must start with `Step N:`.

## Tiny Project Waiver

Only this skill owns the comprehensive-test volume waiver. If the project is tiny or backend-only and 25 comprehensive tests would create fake coverage, add:

```json
{
  "rule": "minimum_25_comprehensive_tests",
  "reason": "Concrete reason",
  "approved_by": "user",
  "date": "YYYY-MM-DD"
}
```

Do not put this waiver in `ARD.md`.

## Handoff

After `feature_list.json` is valid, use `research-enrichment` when research could improve requirements, then `solution-architect`.
