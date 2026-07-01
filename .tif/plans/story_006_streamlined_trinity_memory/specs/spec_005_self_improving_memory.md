---
story_id: story_006
spec_id: spec_005
title: Approval-gated self-improving memory
completed: true
depends_on:
  - spec_002
  - spec_003
  - spec_004
contracts:
  provides:
    - tif.learning.candidate_schema
  consumes:
    - tif.artifact_authority.matrix
    - tif.trinity.workflow
    - tif.research.evidence_record
    - tif.validation.gate_schema
    - external.hermes_agent.memory_design
    - external.memory_poisoning.research
acceptance_checks:
  - id: check_001
    category: functional
    description: Hooks and finish flow stage self-improvement candidates with provenance.
    steps:
      - "Step 1: Trigger a session with a resolved failure mode or user correction."
      - "Step 2: Run /finish or the closeout hook path."
      - "Step 3: Verify a candidate record includes source, target, proposed change, risk flags, and verification command."
    passes: true
  - id: check_002
    category: functional
    description: Durable memory, skill, doc, and test changes require explicit promotion.
    steps:
      - "Step 1: Stage at least one memory candidate and one skill/doc/test candidate."
      - "Step 2: Run the review/promote command without approval and verify nothing is applied."
      - "Step 3: Approve a candidate and verify the target file changes and verification command runs."
    passes: true
  - id: check_003
    category: functional
    description: Memory security checks block unsafe candidates.
    steps:
      - "Step 1: Stage a candidate containing a secret, untrusted instruction, or cross-project assumption."
      - "Step 2: Run memory review."
      - "Step 3: Verify the candidate is rejected or marked requires-user-review with the reason recorded."
    passes: true
---

# Approval-Gated Self-Improving Memory

## Implementation Notes

Current memory is snapshot-oriented:

- `~/.tif/memory/<project-slug>/MEMORY.md`
- `~/.tif/memory/<project-slug>/FAILURES.md`
- `~/.tif/memory/<project-slug>/SESSIONS/`
- `STATE_AUDIT.md`
- `PREAMBLE.md`

Add a candidate-based learning loop:

1. Observe session events, failed commands, user corrections, completed specs, and repeated cleanup findings.
2. Distill candidate lessons with compact provenance.
3. Classify target: project memory, failure mode, skill improvement, docs improvement, test improvement, or rename migration note.
4. Run security checks for secrets, prompt-injection residue, untrusted web content, project leakage, and overbroad rules.
5. Stage candidates under memory, for example `CANDIDATES.jsonl`.
6. Review candidates in `/finish` or `/memory-review`.
7. Promote approved candidates to memory, skills, docs, or tests.
8. Run verification and write the result back to the candidate record.

## Research Findings

The public HERMES Agent repository is a useful reference because its docs describe optional memory-backed prerequisite retrieval for reasoning continuity. It is not an approval-gated memory/skill promotion system, so Tif should borrow the scoped retrieval and provenance idea while adding conservative review, risk checks, and explicit promotion.

Reference: https://github.com/aziksh-ospanov/HERMES

## Candidate Schema

```json
{
  "id": "learn_YYYYMMDD_slug",
  "created_at": "2026-06-29T00:00:00Z",
  "source": {
    "type": "session|failure|user_correction|spec_completion|review",
    "path": "~/.tif/memory/<slug>/SESSIONS/2026-06-29.md",
    "excerpt": "short non-secret summary"
  },
  "target": "memory|failure|skill|doc|test",
  "scope": "project|global",
  "proposal": "short proposed lesson or patch summary",
  "risk_flags": ["untrusted_source"],
  "status": "pending|approved|rejected|promoted",
  "verification": {
    "command": "scripts/check-tif-state.sh .",
    "result": "pending"
  }
}
```

## Design Guidance

Default to project memory, not global skills. Promote to global skills only when a lesson is repeatedly useful across projects and has a regression test.

## TDD Unit-Test Plan

- Unit tests for candidate parsing, risk flagging, and promotion.
- Hook tests confirming candidates can be staged but not promoted automatically.
- Static tests confirming `MEMORY.md` and `FAILURES.md` are not overwritten wholesale.

## Integration / E2E Expectation

After a session with a documented failure and fix, `/finish` should show pending learning candidates. Approving one should patch the intended memory/doc/skill/test target and run verification.

## Owned Files

- `hooks/update-state`
- `hooks/session-start`
- `hooks/pre-compact`
- `hooks/session-end`
- `hooks/codex-stop`
- `skills/update-state/SKILL.md`
- `skills/capturing-failure-modes/SKILL.md`
- New memory review command/skill/script files

## Out Of Scope

- Autonomous global skill mutation without explicit approval.
- Storing secrets or full raw transcripts as promoted memory.
