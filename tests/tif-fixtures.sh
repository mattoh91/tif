#!/usr/bin/env bash
# Shared Tif test fixtures.

run_with_timeout() {
    local seconds="$1"
    shift

    if command -v timeout >/dev/null 2>&1; then
        timeout "$seconds" "$@"
    elif command -v gtimeout >/dev/null 2>&1; then
        gtimeout "$seconds" "$@"
    else
        "$@"
    fi
}

create_tif_docs_fixture() {
    local project_dir="$1"
    local story_dir="$project_dir/.tif/plans/story_001_auth_system"

    mkdir -p "$project_dir/.tif/docs" "$story_dir/specs"

    cat > "$project_dir/.tif/docs/PRD.md" <<'EOF'
---
project_mode: POC
project_context: personal
repo_kind: greenfield
---

# Auth System PRD

## Problem

The test project needs a small authentication system with registration, login, and protected routes.

## Stories

| ID | Story | Acceptance Notes |
| --- | --- | --- |
| story_001 | As a user, I can register and log in. | Registration stores the user and login returns a token. |
EOF

    cat > "$project_dir/.tif/docs/ARCHI.md" <<'EOF'
# Auth System Architecture

```mermaid
flowchart TD
    Client --> AuthAPI
    AuthAPI --> UserStore
```
EOF

    cat > "$project_dir/.tif/docs/CONFIG.md" <<'EOF'
# Auth System Config

| Name | Owner | Type | Default | Required | Allowed Values | Used By | Notes |
| --- | --- | --- | --- | --- | --- | --- | --- |
| `JWT_EXPIRY_SECONDS` | application config | integer | `86400` | yes | positive integer | auth token signer | Token expiry. |
EOF

    cat > "$story_dir/ADR.md" <<'EOF'
# Auth System ADR

## ADR-001: Token-Based Login

Status: Accepted

Problem:

- The fixture needs a simple auth boundary.

Decision:

- Use token-based login with an in-memory user store.
- Implement registration before login.
- Verify the combined auth flow after both specs pass.

Consequences:

- The fixture stays lightweight.
EOF

    cat > "$story_dir/contracts.json" <<'EOF'
{
  "schema_version": "tif.contracts.v1",
  "story_id": "story_001",
  "contracts": [
    {
      "id": "auth.registration.request",
      "provider": "spec_001",
      "consumers": ["spec_002"],
      "schema": {
        "type": "object",
        "required": ["email", "password"]
      }
    },
    {
      "id": "auth.login.response",
      "provider": "spec_002",
      "consumers": [],
      "schema": {
        "type": "object",
        "required": ["token"]
      }
    }
  ],
  "parallel_groups": [["spec_001"], ["spec_002"]]
}
EOF

    cat > "$story_dir/specs/spec_001_registration.md" <<'EOF'
---
story_id: story_001
spec_id: spec_001
title: Registration
completed: false
depends_on: []
contracts:
  provides:
    - auth.registration.request
  consumes: []
acceptance_checks:
  - id: check_001
    category: functional
    description: Registration stores a user with email and password credentials.
    steps:
      - "Step 1: Call the registration entrypoint with a unique email and password."
      - "Step 2: Verify the created user exposes the requested email."
      - "Step 3: Verify credentials are not returned as plaintext in the response."
    passes: false
---

## TDD Unit Tests

- Registers a user with valid credentials.
- Rejects duplicate emails.

## Integration / E2E

Register a user and verify login can use that account.
EOF

    cat > "$story_dir/specs/spec_002_login.md" <<'EOF'
---
story_id: story_001
spec_id: spec_002
title: Login
completed: false
depends_on:
  - spec_001
contracts:
  provides:
    - auth.login.response
  consumes:
    - auth.registration.request
acceptance_checks:
  - id: check_001
    category: functional
    description: Login returns a token for valid credentials.
    steps:
      - "Step 1: Create a registered user fixture."
      - "Step 2: Call the login entrypoint with valid credentials."
      - "Step 3: Verify the response contains a non-empty token."
    passes: false
---

## TDD Unit Tests

- Returns token for valid credentials.
- Rejects invalid credentials.

## Integration / E2E

Register, log in, and call a protected route with the returned token.
EOF
}
