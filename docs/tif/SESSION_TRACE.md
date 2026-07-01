# Tif Session Trace

## Start

SessionStart injects:

- using-tif instructions
- memory and recent sessions
- state checker output
- PRD, architecture, config, repo review when present
- story ADRs, contracts, and specs
- git status and recent commits

## Work

The agent follows:

```text
project-intake -> PRD -> story-planner -> contract-designer -> check state -> build -> documentation -> cleanup -> update-state
```

## End

End-session hooks refresh:

- `STATE_AUDIT.md`
- `PREAMBLE.md`
- session notes under `~/.tif/memory/<project-slug>/SESSIONS/`

The next session resumes from story specs and contracts, not hidden chat context.
