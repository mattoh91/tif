# Story Spec Reviewer Prompt

Review the Cutiepie story planning set.

Inputs:

- `.cutiepie/docs/PRD.md`
- story `plan.md`
- story `ADR.md`
- story `contracts.json`
- story specs

Check:

- every PRD story has a story folder
- every spec has valid frontmatter and acceptance checks
- specs are subagent-ready
- research/tool/library choices are captured in the story ADR
- contracts align providers and consumers
- dependencies and safe parallel groups are sensible

Return blocking issues first.
