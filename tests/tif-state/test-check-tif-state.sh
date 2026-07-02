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

# --- story-level DAG validation (story_009) ---

dag_ok="$tmpdir/dag-ok"
create_tif_docs_fixture "$dag_ok"
perl -0pi -e 's/repo_kind: greenfield/repo_kind: greenfield\nstory_dag:\n  story_001: []/' "$dag_ok/.tif/docs/PRD.md"
assert_passes "$dag_ok" "valid story_dag passes state contract"

dag_dangling="$tmpdir/dag-dangling"
create_tif_docs_fixture "$dag_dangling"
perl -0pi -e 's/repo_kind: greenfield/repo_kind: greenfield\nstory_dag:\n  story_001: [story_777]/' "$dag_dangling/.tif/docs/PRD.md"
assert_fails "$dag_dangling" "story_dag with a dangling reference fails"

# --- story_010 spec_001: category vocabulary + rollup ---

cat_e2e="$tmpdir/cat-e2e"
create_tif_docs_fixture "$cat_e2e"
perl -0pi -e 's/category: functional/category: e2e/' "$cat_e2e/.tif/plans/story_001_auth_system/specs/spec_001_registration.md"
assert_passes "$cat_e2e" "e2e acceptance-check category is accepted"

cat_bogus="$tmpdir/cat-bogus"
create_tif_docs_fixture "$cat_bogus"
perl -0pi -e 's/category: functional/category: banana/' "$cat_bogus/.tif/plans/story_001_auth_system/specs/spec_001_registration.md"
assert_fails "$cat_bogus" "unknown acceptance-check category is rejected"

rollup_out="$("$checker" "$valid" 2>&1 || true)"
if printf '%s' "$rollup_out" | grep -q '\[summary\]'; then
  printf '[PASS] %s\n' "completion rollup summary line present"
else
  printf '[FAIL] %s\n' "completion rollup summary line present"; exit 1
fi

# --- story_010 spec_002: content-hash contract staleness ---

set_json_field() { # file key value
  node -e 'const fs=require("fs");const j=JSON.parse(fs.readFileSync(process.argv[1]));j[process.argv[2]]=process.argv[3];fs.writeFileSync(process.argv[1],JSON.stringify(j,null,2))' "$1" "$2" "$3"
}

hash_ok="$tmpdir/hash-ok"
create_tif_docs_fixture "$hash_ok"
story_h="$hash_ok/.tif/plans/story_001_auth_system"
set_json_field "$story_h/contracts.json" spec_contracts_sha "$(node "$repo_root/scripts/contracts-hash.mjs" "$story_h")"
perl -0pi -e 's/passes: false/passes: true/' "$story_h/specs/spec_001_registration.md"   # non-contract edit
hash_out="$("$checker" "$hash_ok" 2>&1 || true)"
if printf '%s' "$hash_out" | grep -q 'spec_contracts_sha mismatch'; then
  printf '[FAIL] %s\n' "flipping passes does not trip contract staleness"; exit 1
else
  printf '[PASS] %s\n' "flipping passes does not trip contract staleness"
fi

hash_bad="$tmpdir/hash-bad"
create_tif_docs_fixture "$hash_bad"
set_json_field "$hash_bad/.tif/plans/story_001_auth_system/contracts.json" spec_contracts_sha "deadbeef"
bad_out="$("$checker" "$hash_bad" 2>&1 || true)"
if printf '%s' "$bad_out" | grep -q 'spec_contracts_sha mismatch'; then
  printf '[PASS] %s\n' "a wrong spec_contracts_sha reports staleness"
else
  printf '[FAIL] %s\n' "a wrong spec_contracts_sha reports staleness"; exit 1
fi

# --- story_010 spec_003: parked stories ---

make_parked_story() { # target-dir
  mkdir -p "$1/.tif/plans/story_009_parked"
  printf '# Story 009 ADR\n\n## ADR-001: Park it\n\nStatus: Accepted\n\nDecision: design now, build later.\n' \
    > "$1/.tif/plans/story_009_parked/ADR.md"
}

parked_ok="$tmpdir/parked-ok"
create_tif_docs_fixture "$parked_ok"
make_parked_story "$parked_ok"
perl -0pi -e 's/repo_kind: greenfield/repo_kind: greenfield\nparked_stories: [story_009]/' "$parked_ok/.tif/docs/PRD.md"
assert_passes "$parked_ok" "an ADR-only parked story passes"

parked_no="$tmpdir/parked-no"
create_tif_docs_fixture "$parked_no"
make_parked_story "$parked_no"
assert_fails "$parked_no" "the same story fails when not parked (missing specs)"

# --- story_010 spec_004: cross-story / upstream contracts ---

make_downstream() { # target-dir  upstream-ref
  mkdir -p "$1/.tif/plans/story_003_downstream/specs"
  printf '# Story 003 ADR\n\n## ADR-001: Consume\n\nStatus: Accepted\n\nDecision: consume upstream.\n' \
    > "$1/.tif/plans/story_003_downstream/ADR.md"
  cat > "$1/.tif/plans/story_003_downstream/specs/spec_001_consume.md" <<SPEC
---
story_id: story_003
spec_id: spec_001
title: Consume upstream
completed: false
depends_on: []
contracts:
  provides: []
  consumes:
    - auth.registration.request
acceptance_checks:
  - id: check_001
    category: integration
    description: output satisfies the frozen upstream contract.
    steps:
      - "Step 1: verify against the upstream contract."
    passes: false
---
body
SPEC
  printf '{"schema_version":"tif.contracts.v1","story_id":"story_003","contracts":[],"external_contracts":[{"id":"auth.registration.request","upstream":"%s"}]}\n' "$2" \
    > "$1/.tif/plans/story_003_downstream/contracts.json"
  perl -0pi -e 's/repo_kind: greenfield/repo_kind: greenfield\nstory_dag:\n  story_003: [story_001]/' "$1/.tif/docs/PRD.md"
}

up_ok="$tmpdir/upstream-ok"
create_tif_docs_fixture "$up_ok"
make_downstream "$up_ok" "story_001/spec_001"
assert_passes "$up_ok" "a validated upstream contract reference passes"

up_bad="$tmpdir/upstream-bad"
create_tif_docs_fixture "$up_bad"
make_downstream "$up_bad" "story_001/spec_002"
assert_fails "$up_bad" "an upstream ref to a non-provider is rejected (not silently ignored)"

# --- story_010 spec_005: multi-repo awareness ---

unversioned="$tmpdir/unversioned"
create_tif_docs_fixture "$unversioned"   # mktemp dir — not a git repo
unv_out="$("$checker" "$unversioned" 2>&1 || true)"
if printf '%s' "$unv_out" | grep -q 'not under version control'; then
  printf '[PASS] %s\n' "un-versioned .tif emits a warning"
else
  printf '[FAIL] %s\n' "un-versioned .tif emits a warning"; exit 1
fi
assert_passes "$unversioned" "un-versioned .tif is a warning, not a failure"

tracked="$tmpdir/tracked"
create_tif_docs_fixture "$tracked"
perl -0pi -e 's/repo_kind: greenfield/repo_kind: greenfield\nrepo_map:\n  research: research/' "$tracked/.tif/docs/PRD.md"
( cd "$tracked" && git init -q && git add -A && git -c user.email=t@t -c user.name=t commit -qm init >/dev/null 2>&1 ) || true
trk_out="$("$checker" "$tracked" 2>&1 || true)"
if printf '%s' "$trk_out" | grep -q 'not under version control'; then
  printf '[FAIL] %s\n' "git-tracked .tif with repo_map: no un-versioned warning"; exit 1
else
  printf '[PASS] %s\n' "git-tracked .tif with repo_map: no un-versioned warning"
fi
assert_passes "$tracked" "git-tracked .tif with repo_map passes"
