# Story Plan Reviewer Prompt

Review a story-local Cutiepie plan.

Inputs:

- story `plan.md`
- story `ADR.md`
- story `contracts.json`
- story specs

Check:

- `plan.md` describes workflow without duplicating spec completion state
- `ADR.md` records decisions and tradeoffs
- specs define dependencies and acceptance checks
- `contracts.json` aligns with spec contract references
- the story is ready for `/build`
