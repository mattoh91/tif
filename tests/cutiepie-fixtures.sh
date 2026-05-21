#!/usr/bin/env bash
# Shared Cutiepie test fixtures.

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

create_cutiepie_docs_fixture() {
    local project_dir="$1"

    mkdir -p "$project_dir/.cutiepie/docs"

    cat > "$project_dir/.cutiepie/docs/PRD.md" <<'EOF'
# Auth System PRD

## Problem
The test project needs a small authentication system with registration, login, and protected routes.

## User Stories
- As a user, I can register with an email and password.
- As a user, I can log in and receive a token.
- As an API client, I can call protected routes with a valid token.
EOF

    cat > "$project_dir/.cutiepie/docs/feature_list.json" <<'EOF'
{
  "schema_version": "cutiepie.feature_list.v1",
  "scope": {
    "waivers": [
      {
        "rule": "minimum_25_comprehensive_tests",
        "reason": "Small skill-triggering fixture with only enough features to exercise the harness.",
        "approved_by": "test fixture"
      }
    ]
  },
  "features": [
    {
      "id": "F001",
      "category": "functional",
      "description": "Registration stores a user with email and password credentials.",
      "steps": [
        "Step 1: Call the registration entrypoint with a unique email and password.",
        "Step 2: Verify the created user exposes the requested email.",
        "Step 3: Verify credentials are not returned as plaintext in the response."
      ],
      "references": [],
      "implementation_phase": 1,
      "passes": false
    },
    {
      "id": "F002",
      "category": "functional",
      "description": "Login returns a token for valid credentials.",
      "steps": [
        "Step 1: Create a registered user fixture.",
        "Step 2: Call the login entrypoint with valid credentials.",
        "Step 3: Verify the response contains a non-empty token."
      ],
      "references": [],
      "implementation_phase": 1,
      "passes": false
    },
    {
      "id": "F003",
      "category": "functional",
      "description": "Protected routes reject missing or invalid tokens.",
      "steps": [
        "Step 1: Call a protected route without a token.",
        "Step 2: Verify the response is unauthorized.",
        "Step 3: Call the protected route with an invalid token.",
        "Step 4: Verify the response remains unauthorized."
      ],
      "references": [],
      "implementation_phase": 2,
      "passes": false
    }
  ]
}
EOF

    cat > "$project_dir/.cutiepie/docs/ARD.md" <<'EOF'
# Auth System ARD

## Decisions
- Keep the fixture intentionally small so skill-triggering tests remain fast.
- Store any broader coverage waivers in `feature_list.json`, not in ARD.
EOF

    cat > "$project_dir/.cutiepie/docs/ARCHI.md" <<'EOF'
# Auth System Architecture

```xml
<mxfile><diagram name="Auth Fixture"><mxGraphModel><root><mxCell id="0"/><mxCell id="1" parent="0"/></root></mxGraphModel></diagram></mxfile>
```
EOF

    cat > "$project_dir/.cutiepie/docs/CONFIG.md" <<'EOF'
# Auth System Config

| Setting | Default | Owner |
| --- | --- | --- |
| `JWT_EXPIRY_SECONDS` | `86400` | application config |
EOF

    cat > "$project_dir/.cutiepie/docs/PLAN.md" <<'EOF'
# Auth System PLAN

## Bootstrapping
- [ ] Create the project structure and baseline test command.

## Planning
- [ ] Validate `.cutiepie/docs/feature_list.json`.

## Spec-Driven Implementation
- [ ] Complete implementation phase 1.
- [ ] Complete implementation phase 2.

## Documentation
- [ ] Update user-facing documentation.
EOF
}
