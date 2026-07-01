# Story 006 ADR

## ADR-001: Planning Artifacts Have Single Owners

Status: Proposed

Problem:

- The harness is already story-scoped, but PRD, ARCHI, README, ADRs, specs, and command docs still repeat parts of the workflow.
- Repeated state makes it harder for a fresh agent to know which file is authoritative.

Decision:

- Keep `PRD.md` as product/story authority.
- Keep `ARCHI.md` as workflow/component/dataflow authority.
- Keep `CONFIG.md` as settings authority.
- Remove story `plan.md`; keep sequencing in spec dependencies, safe parallel groups in `contracts.json`, and rationale in ADR.
- Keep story `ADR.md` as decision authority.
- Keep `contracts.json` as schema and dependency authority.
- Keep spec frontmatter as completion and acceptance authority.

Consequences:

- The active state model stays small while still being machine-checkable.
- README and command docs can become entrypoint documentation instead of parallel planning state.

## ADR-002: The Public Workflow Uses Socrates, Plato, Aristotle, Finish

Status: Proposed

Problem:

- Current commands are useful but read like a toolkit rather than one memorable delivery path.

Decision:

- Introduce canonical phase commands:
  - `/socrates`: requirements Q&A, intake, PRD stories, unresolved questions.
  - `/plato`: research-driven design, architecture, ADR, specs, and contracts.
  - `/aristotle`: TDD, integration/e2e validation, Playwright where UI is present, acceptance checks.
  - `/finish`: documentation, cleanup, state refresh, and memory review.
- Preserve existing commands as aliases or compatibility commands until the rename migration is complete.

Consequences:

- Users get one story from idea to verified delivery.
- Existing command names do not break immediately.

## ADR-003: Research Is Required Only When Choices Matter

Status: Proposed

Problem:

- Research should improve design quality without turning every small change into an academic exercise.

Decision:

- Trigger the Plato research gate for libraries, frameworks, databases, vector stores, model providers, security-sensitive code, nontrivial algorithms/data structures, and external services.
- Prefer official docs, primary papers, major GitHub repositories, arXiv papers, and security advisories.
- Record chosen and rejected options in the story ADR, with concise evidence notes in the spec.

Consequences:

- The harness remains fast for simple edits and rigorous for consequential design choices.

## ADR-004: Memory Self-Improvement Is Approval-Gated

Status: Proposed

Problem:

- Persistent memory can improve future sessions, but untrusted or over-eager writes can encode bad habits, prompt-injection residue, secrets, or project-specific assumptions.

Decision:

- Stage memory, failure-mode, skill, doc, and test improvements as candidates with source provenance, confidence, target, proposed patch, risk flags, and verification commands.
- Promote candidates only after user approval or an explicit trusted automation setting.
- Keep project memory separate from global skill improvements.

Consequences:

- The loop can learn from experience without silently mutating the harness.
- The design follows Hermes-agent's useful pattern of memory and skill improvement while adding conservative promotion gates.

## ADR-005: Rename To Gummy

Status: Superseded by ADR-006

Problem:

- The old Cutiepie namespace and a short-lived Method rename proposal appeared across plugin manifests, commands, hooks, docs, tests, memory paths, package metadata, and sync scripts.

Decision:

- Use `Gummy` / `gummy` as the selected brand and namespace.
- Rename code paths, command names, memory root, plugin metadata, docs, tests, and compatibility notes together.

Consequences:

- The public harness name is cute, short, and CLI-friendly.
- Future compatibility notes should refer old Cutiepie/Method-era installs to the Gummy namespace.

## ADR-006: Rename To Tif

Status: Accepted

Problem:

- After the Gummy rename (ADR-005), the harness was renamed again to Tif. The naming lineage is Cutiepie → Gummy → Tif.

Decision:

- Use `Tif` / `tif` as the selected brand and namespace.
- Rename code paths, command names, memory root, plugin metadata, docs, tests, and compatibility notes together, plus the local repo directory and the Claude Code project memory directory.

Consequences:

- All active surfaces use the `tif` namespace and `.tif/` state root.
- Compatibility notes should refer old Cutiepie/Gummy-era installs to the Tif namespace.

## Rename Decision

Selected name: Tif

| Surface | New Value |
| --- | --- |
| Brand | Tif |
| CLI/plugin namespace | `tif` |
| Active state root | `.tif/` |
| Durable memory root | `~/.tif/memory/` |
| Core orientation skill | `using-tif` |
| State checker | `scripts/check-tif-state.sh` |
