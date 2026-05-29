#!/usr/bin/env bash
set -euo pipefail

script_dir="$(cd "$(dirname "$0")" && pwd)"
repo_root="$(cd "$script_dir/../.." && pwd)"

adapter="$repo_root/skills/multi-agent-adapter/SKILL.md"
using_cutiepie="$repo_root/skills/using-cutiepie/SKILL.md"
guidelines="$repo_root/docs/cutiepie/AGENTIC_ENGINEERING_GUIDELINES.md"

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

assert_file "$adapter" "multi-agent-adapter skill exists"
assert_contains "$adapter" "Claude Code" "adapter documents Claude Code host mapping"
assert_contains "$adapter" "Codex" "adapter documents Codex host mapping"
assert_contains "$adapter" "Cursor" "adapter documents Cursor host mapping"
assert_contains "$adapter" "Copilot" "adapter documents Copilot host mapping"
assert_contains "$adapter" "Gemini" "adapter documents Gemini host mapping"
assert_contains "$adapter" "inline fallback" "adapter documents inline fallback"
assert_contains "$adapter" "Task Packet" "adapter requires self-contained task packets"

assert_contains "$repo_root/skills/build/SKILL.md" "multi-agent-adapter" "build skill routes dispatch through adapter"
assert_contains "$repo_root/skills/subagent-driven-spec-development/SKILL.md" "multi-agent-adapter" "spec-development skill routes dispatch through adapter"
assert_contains "$repo_root/skills/subagent-driven-development/SKILL.md" "multi-agent-adapter" "development compatibility skill routes dispatch through adapter"
assert_contains "$repo_root/skills/requesting-code-review/SKILL.md" "multi-agent-adapter" "code review skill routes dispatch through adapter"
assert_contains "$repo_root/skills/dispatching-parallel-agents/SKILL.md" "multi-agent-adapter" "parallel dispatch skill routes dispatch through adapter"
assert_contains "$repo_root/skills/using-cutiepie/references/codex-tools.md" "multi-agent-adapter" "Codex tool mapping points to adapter"
assert_contains "$repo_root/README.md" "multi-agent-adapter" "README documents runtime adapter"

assert_contains "$using_cutiepie" ".cutiepie/plans/story_<nnn>_<slug>/" "using-cutiepie declares story folder state"
assert_contains "$using_cutiepie" "Spec frontmatter owns completion state" "using-cutiepie keeps completion state in specs"
assert_contains "$using_cutiepie" '`contracts.json` owns cross-spec schemas' "using-cutiepie keeps contracts in story folder"
assert_contains "$guidelines" "A spec is complete only when" "engineering guidelines define spec completion"

if [ "$failures" -gt 0 ]; then
  exit 1
fi
