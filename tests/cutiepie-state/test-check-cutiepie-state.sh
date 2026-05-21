#!/usr/bin/env bash
set -euo pipefail

script_dir="$(cd "$(dirname "$0")" && pwd)"
repo_root="$(cd "$script_dir/../.." && pwd)"
checker="$repo_root/scripts/check-cutiepie-state.sh"
tmpdir="$(mktemp -d)"
trap 'rm -rf "$tmpdir"' EXIT

copy_scaffold() {
  local target="$1"
  mkdir -p "$target/.cutiepie/docs"
  cp -R "$repo_root/skills/scaffolding-repo/template/.cutiepie/docs/." "$target/.cutiepie/docs/"
}

assert_passes() {
  local target="$1"
  local label="$2"
  if "$checker" "$target" >/tmp/cutiepie-state-pass.log 2>&1; then
    printf '[PASS] %s\n' "$label"
  else
    printf '[FAIL] %s\n' "$label"
    cat /tmp/cutiepie-state-pass.log
    exit 1
  fi
}

assert_fails() {
  local target="$1"
  local label="$2"
  if "$checker" "$target" >/tmp/cutiepie-state-fail.log 2>&1; then
    printf '[FAIL] %s\n' "$label"
    cat /tmp/cutiepie-state-fail.log
    exit 1
  else
    printf '[PASS] %s\n' "$label"
  fi
}

valid="$tmpdir/valid"
copy_scaffold "$valid"
assert_passes "$valid" "valid scaffold passes state contract"

duplicate="$tmpdir/duplicate"
copy_scaffold "$duplicate"
cat >> "$duplicate/.cutiepie/docs/PLAN.md" <<'EOF'

## Bad Duplicate

- [x] F001 passes true
EOF
assert_fails "$duplicate" "PLAN.md cannot duplicate feature pass/fail state"

phase="$tmpdir/phase"
copy_scaffold "$phase"
cat > "$phase/.cutiepie/docs/feature_list.json" <<'EOF'
{
  "schema_version": "1.0",
  "scope": {
    "size": "tiny",
    "waivers": [
      {
        "rule": "minimum_25_comprehensive_tests",
        "reason": "Tiny fixture for validator testing.",
        "approved_by": "test",
        "date": "2026-05-22"
      }
    ]
  },
  "features": [
    {
      "id": "F001",
      "user_story_ids": ["US001"],
      "category": "functional",
      "priority": 1,
      "description": "Phase one feature.",
      "steps": [
        "Step 1: Run phase one setup.",
        "Step 2: Verify phase one result."
      ],
      "references": [],
      "dependencies": [],
      "implementation_phase": 1,
      "passes": false
    },
    {
      "id": "F002",
      "user_story_ids": ["US001"],
      "category": "functional",
      "priority": 2,
      "description": "Phase two feature.",
      "steps": [
        "Step 1: Run phase two setup.",
        "Step 2: Verify phase two result."
      ],
      "references": [],
      "dependencies": ["F001"],
      "implementation_phase": 2,
      "passes": false
    }
  ]
}
EOF
cat >> "$phase/.cutiepie/docs/PLAN.md" <<'EOF'

## Spec-Driven Development

- [x] Phase 2 implementation complete.
EOF
assert_fails "$phase" "later phase cannot be complete before earlier phase passes"
