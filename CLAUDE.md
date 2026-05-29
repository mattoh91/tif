# Cutiepie Repository Instructions

When working in this repo:

1. Read `skills/using-cutiepie/SKILL.md`.
2. Keep changes grounded in `.cutiepie/docs/PRD.md` and `.cutiepie/plans/story_*/`.
3. Use `scripts/check-cutiepie-state.sh .` before claiming Cutiepie state is valid.
4. Story specs own completion through `completed` and `acceptance_checks[*].passes`.
5. Story `contracts.json` owns cross-spec schemas.
6. Story `ADR.md` owns story-level decisions.
7. Run documentation, cleanup, and update-state before ending substantial work.

Active Cutiepie state:

```text
.cutiepie/docs/PRD.md
.cutiepie/docs/ARCHI.md
.cutiepie/docs/CONFIG.md
.cutiepie/plans/story_*/plan.md
.cutiepie/plans/story_*/ADR.md
.cutiepie/plans/story_*/contracts.json
.cutiepie/plans/story_*/specs/spec_*.md
```

Do not introduce alternate planning locations. Do not use a separate global feature list or global implementation plan.

For Heineken projects, ask before publishing to Confluence and document Brewery/Atlassian setup in config and story docs.
