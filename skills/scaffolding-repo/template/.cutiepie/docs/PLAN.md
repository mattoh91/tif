# Project Plan

This file owns workflow progress only. Feature pass/fail state lives only in `feature_list.json`.

## Bootstrapping

- [ ] Detect stack and package manager.
- [ ] Create init, fmt, lint, typecheck, test, smoke, and ci commands.
- [ ] Create `.cutiepie/docs/` artifacts.
- [ ] Create out-of-tree memory directory.

## Planning

- [ ] Gather requirements into `PRD.md`.
- [ ] Derive `feature_list.json` from `PRD.md`.
- [ ] Enrich `feature_list.json` with research citations.
- [ ] Create `ARD.md` with assumptions, caveats, and decisions.
- [ ] Create `CONFIG.md` with environment variables and tunables.
- [ ] Create `ARCHI.md` with draw.io dataflow diagram.
- [ ] Assign `implementation_phase` values in `feature_list.json`.

## Spec Review

- [ ] Validate `feature_list.json` schema.
- [ ] Confirm every user story maps to feature specs.
- [ ] Confirm every feature has executable steps.
- [ ] Confirm dependencies match `ARCHI.md`.
- [ ] User approves planning artifacts.

## Spec-Driven Development

- [ ] Phase 1 started.
- [ ] Phase 1 implementation complete.
- [ ] Phase 1 feature checks all pass according to `feature_list.json`.
- [ ] Phase 1 committed.

## Documentation

- [ ] Create `deck.html`.
- [ ] Add interactive architecture diagram.
- [ ] Add DTO/interface and citation cards.
- [ ] Verify deck navigation and rendering.

## Completion

- [ ] Run full CI.
- [ ] Run all feature steps.
- [ ] Refresh state and memory.
- [ ] Present merge/PR/keep/discard options.
