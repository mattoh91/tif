#!/usr/bin/env bash
set -euo pipefail

script_dir="$(cd "$(dirname "$0")" && pwd)"
repo_root="$(cd "$script_dir/../.." && pwd)"
template="$repo_root/skills/scaffolding-repo/template"
skill="$repo_root/skills/scaffolding-repo/SKILL.md"
intake="$repo_root/skills/project-intake/SKILL.md"

failures=0

assert_file() {
  local path="$1"
  local label="$2"
  if [ -f "$path" ]; then
    printf '[PASS] %s\n' "$label"
  else
    printf '[FAIL] %s\n' "$label"
    failures=$((failures + 1))
  fi
}

assert_absent() {
  local path="$1"
  local label="$2"
  if [ ! -e "$path" ]; then
    printf '[PASS] %s\n' "$label"
  else
    printf '[FAIL] %s\n' "$label"
    failures=$((failures + 1))
  fi
}

assert_contains() {
  local path="$1"
  local needle="$2"
  local label="$3"
  if grep -Fq "$needle" "$path"; then
    printf '[PASS] %s\n' "$label"
  else
    printf '[FAIL] %s\n' "$label"
    failures=$((failures + 1))
  fi
}

assert_file "$template/.tif/docs/PRD.md" "scaffold includes PRD.md"
assert_file "$template/.tif/docs/ARCHI.md" "scaffold includes ARCHI.md"
assert_file "$template/.tif/docs/CONFIG.md" "scaffold includes CONFIG.md"
assert_absent "$template/.tif/plans/story_001_initial_workflow/plan.md" "scaffold omits story plan"
assert_file "$template/.tif/plans/story_001_initial_workflow/ADR.md" "scaffold includes story ADR"
assert_file "$template/.tif/plans/story_001_initial_workflow/contracts.json" "scaffold includes story contracts"
assert_file "$template/.tif/plans/story_001_initial_workflow/specs/spec_001_initial_slice.md" "scaffold includes story spec"
doc_count="$(find "$template/.tif/docs" -maxdepth 1 -type f | wc -l | tr -d ' ')"
if [ "$doc_count" -eq 3 ]; then
  printf '[PASS] scaffold docs contain only current top-level docs\n'
else
  printf '[FAIL] scaffold docs contain unexpected top-level docs\n'
  failures=$((failures + 1))
fi
assert_contains "$skill" "Brownfield Adoption" "scaffold skill documents brownfield adoption"
assert_contains "$skill" "Brewery / GenAI Gateway Client" "scaffold skill documents brewery client"
assert_contains "$skill" "Atlassian MCP" "scaffold skill documents Atlassian MCP"
assert_contains "$intake" "greenfield" "project-intake detects greenfield"
assert_contains "$intake" "brownfield" "project-intake detects brownfield"
assert_contains "$intake" "Heineken" "project-intake detects Heineken"
assert_file "$repo_root/skills/scaffolding-repo/references/brewery-client.py" "brewery client reference exists"
assert_file "$repo_root/skills/scaffolding-repo/references/brewery-client.md" "brewery client docs reference exists"

if [ "$failures" -gt 0 ]; then
  exit 1
fi
