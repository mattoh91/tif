# Gummy Repository Instructions

When working in this repo:

1. Read `skills/using-gummy/SKILL.md`.
2. Keep changes grounded in `.gummy/docs/PRD.md` and `.gummy/plans/story_*/`.
3. Use `scripts/check-gummy-state.sh .` before claiming Gummy state is valid.
4. Story specs own completion through `completed` and `acceptance_checks[*].passes`.
5. Story `contracts.json` owns cross-spec schemas.
6. Story `ADR.md` owns story-level decisions.
7. Run documentation, cleanup, and update-state before ending substantial work.

Active Gummy state:

```text
.gummy/docs/PRD.md
.gummy/docs/ARCHI.md
.gummy/docs/CONFIG.md
.gummy/plans/story_*/ADR.md
.gummy/plans/story_*/contracts.json
.gummy/plans/story_*/specs/spec_*.md
```

Do not introduce alternate planning locations. Do not use a separate global feature list or global implementation plan.

For Heineken projects, ask before publishing to Confluence and document Brewery/Atlassian setup in config and story docs.
