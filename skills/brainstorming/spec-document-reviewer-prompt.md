# Story Spec Reviewer Prompt

Review the Gummy story planning set.

Inputs:

- `.gummy/docs/PRD.md`
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
