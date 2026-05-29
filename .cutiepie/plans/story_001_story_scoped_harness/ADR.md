# Story 001 ADR

## ADR-001: Story Folders Own Execution State

Status: Accepted

Problem:

- Separate cross-story trackers duplicate story/spec state once each story has its own implementation specs and acceptance checks.

Decision:

- `PRD.md` owns human stories.
- `.cutiepie/plans/story_*/plan.md` owns story workflow.
- `.cutiepie/plans/story_*/specs/spec_*.md` owns spec completion state, dependencies, contract references, and acceptance checks.
- `.cutiepie/plans/story_*/contracts.json` owns cross-spec data contracts after specs are drafted.
- Each story folder has its own `ADR.md`.

Consequences:

- Session resume can scan specs for `completed: true/false`.
- Parallel subagents get explicit contracts and non-overlapping scopes.
- The harness no longer needs separate global completion, workflow, or house-rules files.

## ADR-002: Contracts Are Designed After Specs

Status: Accepted

Problem:

- Contracts cannot be designed well before specs identify boundaries, inputs, outputs, and external dependencies.

Decision:

- Draft specs first.
- Run `contract-designer` as a required planning gate.
- Validate the resulting `contracts.json` mechanically before build.

Consequences:

- Contract design remains a reasoning step, not a hidden hook side effect.
- Hooks and scripts only detect missing or stale contracts.

## ADR-003: Documentation And Cleanup Close Every Session

Status: Accepted

Problem:

- Long-running agent work accumulates stale state, orphaned specs, and undocumented decisions.

Decision:

- End-session workflow includes documentation and cleanup before memory refresh.
- Heineken projects prepare Confluence-ready documentation and ask for approval plus target location before publishing.

Consequences:

- Personal projects stay lightweight.
- Heineken projects get durable GenAILab documentation without accidental publishing.

## ADR-004: Intake Detects Before Asking

Status: Accepted

Problem:

- Hephaestus-style init flows contain useful questions, but a personal harness becomes noisy if it asks everything up front.

Decision:

- `project-intake` inspects repo and Cutiepie state first.
- It asks only unresolved decision questions, 1-2 at a time.
- Heineken-specific Jira, Confluence, Brewery, and Atlassian MCP questions are deferred until Heineken context is confirmed.
- Brownfield convention questions happen after the repo review, when the agent can name the actual conventions it found.

Consequences:

- Cutiepie keeps Hephaestus' useful gates without inheriting a heavyweight questionnaire.
- User answers become durable PRD/config/story inputs rather than one-off chat state.
