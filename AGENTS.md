# Tif Repository Instructions

When working in this repo:

1. Read `skills/using-tif/SKILL.md`.
2. Keep changes grounded in `.tif/docs/PRD.md` and `.tif/plans/story_*/`.
3. Use `scripts/check-tif-state.sh .` before claiming Tif state is valid.
4. Story specs own completion through `completed` and `acceptance_checks[*].passes`.
5. Story `contracts.json` owns cross-spec schemas.
6. Story `ADR.md` owns story-level decisions.
7. Run documentation, cleanup, and update-state before ending substantial work.

Active Tif state:

```text
.tif/docs/PRD.md
.tif/docs/ARCHI.md
.tif/docs/CONFIG.md
.tif/plans/story_*/ADR.md
.tif/plans/story_*/contracts.json
.tif/plans/story_*/specs/spec_*.md
```

Do not introduce alternate planning locations. Do not use a separate global feature list or global implementation plan.

For Heineken projects, ask before publishing to Confluence and document Brewery/Atlassian setup in config and story docs.
