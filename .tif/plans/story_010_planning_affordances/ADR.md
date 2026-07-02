# Story 010 ADR

Dogfooding cartographer surfaced friction points that are missing affordances,
not model errors. Each is addressed below. (Feedback item #2 — weight as schema —
already shipped in story_008; #7 rollup is a rider on ADR-001.)

## ADR-001: Richer Acceptance-Check Category Vocabulary (#3)

Status: Accepted

Problem: `category` allowed only `functional|style`, forcing live-network e2e
checks to be mislabeled `functional` — erasing the unit-vs-integration
distinction the "never claim done from unit tests" rule depends on.

Decision: allow `functional | integration | e2e | style | security`. Also emit a
completion rollup on the checker's summary line (rider #7).

## ADR-002: Content-Hash Contract Staleness, Not mtime (#5)

Status: Accepted

Problem: flipping a `passes` flag touches a spec's mtime, so `contracts.json`
looked stale even though no contract declaration changed; `touch` silenced it.

Decision: staleness is a hash of every spec's `provides`/`consumes` (the only
thing contracts.json depends on), stored as `spec_contracts_sha` in
contracts.json. Editing unrelated spec fields no longer trips it. Absent hash →
no staleness warning (better than mtime false positives). `contract-designer`
writes the hash.

## ADR-003: Parked Stories (#1)

Status: Accepted

Problem: planning is incremental — an ADR can exist sessions before specs — but
an ADR-only story folder fails the checker (missing specs directory).

Decision: `parked_stories: [story_nnn]` in PRD frontmatter. A parked story is
exempt from the specs/ADR/contracts structural requirements; whatever files
exist are still validated. Un-park by removing it from the list once specs land.

## ADR-004: First-Class Cross-Story / Upstream Contracts (#4)

Status: Accepted

Problem: a downstream story consuming a contract frozen by an earlier story
(story_002's output must satisfy story_001's validator) could not be expressed —
the provider must be a spec in the same story — and the `external_invariants`
workaround was silently ignored (worse than rejected).

Decision: `external_contracts` entries may carry `upstream: "story_001/spec_004"`.
The checker validates it: the referenced story + spec exist, that spec `provides`
the contract id, AND the consuming story has a `story_dag` edge to the upstream
story. A consumed contract satisfied by a validated upstream ref is accepted.
Unvalidatable upstream refs now fail instead of being ignored.

## ADR-005: Multi-Repo Awareness (#6)

Status: Accepted

Problem: tif assumes one repo; a container orchestrating sub-repos leaves `.tif/`
at a parent that may not be under version control — planning state silently at risk.

Decision: optional `repo_map` in PRD frontmatter names sub-repos and their roles.
The checker emits a **warning** (not a failure) when `.tif/` exists but is not
tracked by git, so un-versioned planning state is surfaced.
