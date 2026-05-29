#!/usr/bin/env bash
set -euo pipefail

script_dir="$(cd "$(dirname "$0")" && pwd)"
repo_root="$(cd "$script_dir/../.." && pwd)"

failures=0

assert_contains() {
  local path="$1"
  local needle="$2"
  local label="$3"
  if grep -Fq "$needle" "$path"; then
    printf '[PASS] %s\n' "$label"
  else
    printf '[FAIL] %s\n' "$label"
    printf '  Missing "%s" in %s\n' "$needle" "$path"
    failures=$((failures + 1))
  fi
}

assert_contains "$repo_root/skills/project-intake/SKILL.md" "greenfield" "intake detects greenfield"
assert_contains "$repo_root/skills/project-intake/SKILL.md" "brownfield" "intake detects brownfield"
assert_contains "$repo_root/skills/project-intake/SKILL.md" "Heineken" "intake detects Heineken"
assert_contains "$repo_root/skills/project-intake/SKILL.md" "Brewery" "intake includes Brewery client"
assert_contains "$repo_root/skills/project-intake/SKILL.md" "Atlassian MCP" "intake includes Atlassian MCP"
assert_contains "$repo_root/skills/project-intake/SKILL.md" "REPO_REVIEW.md" "brownfield creates repo review"
assert_contains "$repo_root/skills/project-intake/SKILL.md" "Detect before asking" "intake detects before asking"
assert_contains "$repo_root/skills/project-intake/SKILL.md" "Ask 1-2 questions at a time" "intake limits question count"
assert_contains "$repo_root/skills/project-intake/SKILL.md" "POC or MVP mode" "intake asks for POC or MVP"
assert_contains "$repo_root/skills/project-intake/SKILL.md" "treat them as binding" "intake asks about brownfield conventions"
assert_contains "$repo_root/skills/project-intake/SKILL.md" "GenAILab Confluence parent page" "intake asks Confluence target"
assert_contains "$repo_root/skills/project-intake/SKILL.md" "Jira project" "intake asks Jira target"

assert_contains "$repo_root/skills/story-planner/SKILL.md" ".cutiepie/plans/story_001_short_slug/" "story-planner defines story folder"
assert_contains "$repo_root/skills/story-planner/SKILL.md" "completed: false" "story-planner defines completed flag"
assert_contains "$repo_root/skills/story-planner/SKILL.md" "acceptance_checks" "story-planner defines acceptance checks"
assert_contains "$repo_root/skills/story-planner/SKILL.md" "contract-designer" "story-planner hands off to contract designer"

assert_contains "$repo_root/skills/contract-designer/SKILL.md" "contracts.json" "contract-designer writes contracts"
assert_contains "$repo_root/skills/contract-designer/SKILL.md" "provider" "contract-designer defines providers"
assert_contains "$repo_root/skills/contract-designer/SKILL.md" "consumers" "contract-designer defines consumers"
assert_contains "$repo_root/skills/contract-designer/SKILL.md" "scripts/check-cutiepie-state.sh ." "contract-designer runs state checker"

assert_contains "$repo_root/skills/build/SKILL.md" "completed: false" "build scans incomplete specs"
assert_contains "$repo_root/skills/build/SKILL.md" "acceptance checks" "build verifies acceptance checks"
assert_contains "$repo_root/skills/build/SKILL.md" "documentation" "build runs documentation"
assert_contains "$repo_root/skills/build/SKILL.md" "cleanup" "build runs cleanup"

assert_contains "$repo_root/skills/documentation/SKILL.md" "Confluence" "documentation supports Confluence"
assert_contains "$repo_root/skills/documentation/SKILL.md" "GenAILab" "documentation targets GenAILab"
assert_contains "$repo_root/skills/documentation/SKILL.md" "approval" "documentation requires approval"
assert_contains "$repo_root/skills/cleanup/SKILL.md" "orphaned" "cleanup checks orphaned state"
assert_contains "$repo_root/skills/cleanup/SKILL.md" "stale contracts" "cleanup checks stale contracts"
assert_contains "$repo_root/skills/cleanup/SKILL.md" "scripts/check-cutiepie-state.sh ." "cleanup runs state checker"

assert_contains "$repo_root/README.md" "/intake" "README documents intake command"
assert_contains "$repo_root/README.md" "/contracts" "README documents contracts command"
assert_contains "$repo_root/README.md" "/document" "README documents documentation command"
assert_contains "$repo_root/README.md" "/cleanup" "README documents cleanup command"

if [ "$failures" -gt 0 ]; then
  exit 1
fi
