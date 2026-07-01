#!/usr/bin/env bash
set -euo pipefail

script_dir="$(cd "$(dirname "$0")" && pwd)"
repo_root="$(cd "$script_dir/../.." && pwd)"
checker="$repo_root/scripts/check-tif-state.sh"
fixtures="$repo_root/tests/tif-fixtures.sh"
tmpdir="$(mktemp -d)"
trap 'rm -rf "$tmpdir"' EXIT

# shellcheck source=../tif-fixtures.sh
. "$fixtures"

copy_scaffold() {
  local target="$1"
  mkdir -p "$target"
  cp -R "$repo_root/skills/scaffolding-repo/template/." "$target/"
}

assert_passes() {
  local target="$1"
  local label="$2"
  if "$checker" "$target" >/tmp/tif-state-pass.log 2>&1; then
    printf '[PASS] %s\n' "$label"
  else
    printf '[FAIL] %s\n' "$label"
    cat /tmp/tif-state-pass.log
    exit 1
  fi
}

assert_fails() {
  local target="$1"
  local label="$2"
  if "$checker" "$target" >/tmp/tif-state-fail.log 2>&1; then
    printf '[FAIL] %s\n' "$label"
    cat /tmp/tif-state-fail.log
    exit 1
  else
    printf '[PASS] %s\n' "$label"
  fi
}

valid="$tmpdir/valid"
create_tif_docs_fixture "$valid"
assert_passes "$valid" "valid story fixture passes state contract"

scaffold="$tmpdir/scaffold"
copy_scaffold "$scaffold"
assert_passes "$scaffold" "scaffold template passes state contract"

missing_contracts="$tmpdir/missing-contracts"
create_tif_docs_fixture "$missing_contracts"
rm "$missing_contracts/.tif/plans/story_001_auth_system/contracts.json"
assert_fails "$missing_contracts" "story specs require contracts.json"

bad_completion="$tmpdir/bad-completion"
create_tif_docs_fixture "$bad_completion"
perl -0pi -e 's/completed: false/completed: true/' "$bad_completion/.tif/plans/story_001_auth_system/specs/spec_001_registration.md"
assert_fails "$bad_completion" "completed specs require passing acceptance checks"

missing_contract_ref="$tmpdir/missing-contract-ref"
create_tif_docs_fixture "$missing_contract_ref"
perl -0pi -e 's/auth.registration.request/auth.registration.missing/' "$missing_contract_ref/.tif/plans/story_001_auth_system/specs/spec_002_login.md"
assert_fails "$missing_contract_ref" "consumed contracts must exist"

cycle="$tmpdir/cycle"
create_tif_docs_fixture "$cycle"
perl -0pi -e 's/depends_on: \[\]/depends_on:\n  - spec_002/' "$cycle/.tif/plans/story_001_auth_system/specs/spec_001_registration.md"
assert_fails "$cycle" "cyclic spec dependencies fail"

# --- weight: spike relaxation (story_008) ---

spike_lean="$tmpdir/spike-lean"
create_tif_docs_fixture "$spike_lean"
spike_story="$spike_lean/.tif/plans/story_001_auth_system"
perl -0pi -e 's/^completed: (true|false)$/completed: $1\nweight: spike/m' "$spike_story"/specs/spec_*.md
rm -f "$spike_story/ADR.md" "$spike_story/contracts.json"
assert_passes "$spike_lean" "spike-weight story omits ADR.md and contracts.json"

full_needs_adr="$tmpdir/full-needs-adr"
create_tif_docs_fixture "$full_needs_adr"
rm -f "$full_needs_adr/.tif/plans/story_001_auth_system/ADR.md"
assert_fails "$full_needs_adr" "full-weight story still requires ADR.md"
