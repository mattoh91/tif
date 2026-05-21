---
name: brainstorming
description: "You MUST use this before creative project work unless the user has already approved the design; routes Cutiepie planning through PRD, feature list, research, architecture, and PLAN artifacts."
---

# Brainstorming Ideas Into Specs

Use this skill to move from an idea to approved planning artifacts under `.cutiepie/docs/`.

## Hard Gate

Do not implement code until the user has approved the planning artifacts or explicitly asks to bypass planning.

## Canonical Artifacts

Active artifacts live only under `.cutiepie/docs/`:

- `PRD.md`
- `feature_list.json`
- `ARD.md`
- `ARCHI.md`
- `CONFIG.md`
- `PLAN.md`

`feature_list.json` owns individual feature completion through `passes`. `PLAN.md` owns workflow progress only.

## Workflow

1. Inspect repo context, existing `.cutiepie/docs/`, README, and recent commits.
2. Use `prd-discovery` to create or update `PRD.md` through Socratic Q&A.
3. Use `feature-list-builder` to derive `feature_list.json` from user stories.
4. Use `research-enrichment` when research can improve requirements; prioritize primary papers, major AI lab materials, and major relevant repos.
5. Use `solution-architect` to create `ARD.md` and `ARCHI.md` with draw.io dataflow.
6. Use `implementation-sequencer` to set `implementation_phase` values in `feature_list.json`.
7. Use `progress-planner` to create or update `PLAN.md`.
8. Run `scripts/check-cutiepie-state.sh .`.
9. Ask the user to approve the artifacts before implementation.

## Tiny Project Policy

Tiny or backend-only projects may waive the 25 comprehensive-feature requirement only through an explicit waiver in `feature_list.json`, created by `feature-list-builder`. Do not put this waiver in `ARD.md`.

## Handoff

After user approval, implementation uses `subagent-driven-spec-development` or, on hosts exposing only legacy names, `subagent-driven-development`.
