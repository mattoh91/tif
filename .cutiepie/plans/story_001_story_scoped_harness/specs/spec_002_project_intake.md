---
story_id: story_001
spec_id: spec_002
title: Project intake for greenfield, brownfield, personal, and Heineken projects
completed: true
depends_on:
  - spec_001
contracts:
  provides:
    - cutiepie.project_intake.profile
  consumes:
    - cutiepie.story_state.layout
acceptance_checks:
  - id: check_001
    category: functional
    description: New project intake guides the agent to classify repo shape and project context before planning.
    steps:
      - "Step 1: Read the project-intake skill."
      - "Step 2: Verify it detects greenfield vs brownfield from repo signals."
      - "Step 3: Verify it asks the user to confirm personal vs Heineken when unclear."
    passes: true
  - id: check_002
    category: functional
    description: Heineken intake includes Brewery client and Atlassian MCP setup.
    steps:
      - "Step 1: Read project-intake and scaffolding-repo skills."
      - "Step 2: Verify Heineken projects include Brewery client setup."
      - "Step 3: Verify Heineken projects include Atlassian MCP setup guidance."
    passes: true
  - id: check_003
    category: functional
    description: Intake uses an adaptive question ladder rather than a broad questionnaire.
    steps:
      - "Step 1: Verify project-intake says to detect before asking."
      - "Step 2: Verify it asks at most 1-2 unresolved decision questions at a time."
      - "Step 3: Verify Heineken-specific questions are deferred until Heineken is confirmed."
    passes: true
---

## Implementation Notes

Add `project-intake` as the first planning step. Brownfield projects should get a repo review plus architecture baseline before stories/specs. Heineken projects should ask for confirmation and bootstrap enterprise integrations. Intake should inspect first and ask only unresolved decision questions such as POC vs MVP mode, binding brownfield conventions, Jira target, Confluence target, and Brewery setup.

## Research / Tooling

No external dependency is needed. Use existing repo signals: package files, CI files, source directories, test directories, infra files, git remote, and known organization naming.

## TDD Unit Tests

- Static contract test confirms the skill names greenfield, brownfield, Heineken, Brewery client, Atlassian MCP, repo review, adaptive question ladder, and architecture diagrams.

## Integration / E2E

Start from a brownfield fixture and verify the scaffold workflow creates `REPO_REVIEW.md`, updates `ARCHI.md`, asks whether detected conventions are binding, and asks before Heineken-specific setup when detection is uncertain.
