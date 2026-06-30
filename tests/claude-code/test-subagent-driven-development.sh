#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/test-helpers.sh"

echo "=== Test: subagent-driven-development skill ==="

output=$(run_claude "What is the subagent-driven-development skill? Describe its story-spec workflow briefly." 30)
assert_contains "$output" "subagent-driven-development\|Subagent-Driven Development\|story spec\|contracts" "Skill is recognized"
assert_contains "$output" "completed.*false\|specs.*contracts\|acceptance" "Mentions story spec state"

output=$(run_claude "Before using subagent-driven-development, what state checker and story artifacts should be valid?" 30)
assert_contains "$output" "check-gummy-state\|contracts.json\|spec_.*md\|ADR" "Mentions story state contract"

output=$(run_claude "When can a Gummy story spec be marked completed=true?" 30)
assert_contains "$output" "acceptance.*pass\|passes.*true\|only.*after" "Requires acceptance checks to pass"

echo "=== subagent-driven-development skill smoke tests passed ==="
