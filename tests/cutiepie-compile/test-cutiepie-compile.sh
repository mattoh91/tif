#!/usr/bin/env bash
set -euo pipefail

script_dir="$(cd "$(dirname "$0")" && pwd)"
repo_root="$(cd "$script_dir/../.." && pwd)"
compiler="$repo_root/scripts/cutiepie-compile.py"
tmpdir="$(mktemp -d)"
trap 'rm -rf "$tmpdir"' EXIT

mkdir -p "$tmpdir/source/example"
cat > "$tmpdir/source/example/SKILL.md" <<'EOF'
---
name: example
description: Example skill for compiler tests.
---

# Example

Use this for compiler tests.
EOF

python3 "$compiler" "$tmpdir/source" --all --output "$tmpdir/out" >/tmp/cutiepie-compile.log

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
    failures=$((failures + 1))
  fi
}

assert_file "$tmpdir/out/example/SKILL.md" "Claude/Copilot SKILL.md emitted"
assert_file "$tmpdir/out/.cursor/rules/example.md" "Cursor rule emitted"
assert_file "$tmpdir/out/AGENTS.md" "Codex AGENTS.md emitted"
assert_contains "$tmpdir/out/AGENTS.md" "<!-- cutiepie-compile:example -->" "Codex section marker emitted"
assert_contains "$tmpdir/out/.cursor/rules/example.md" "alwaysApply: false" "Cursor rule is opt-in"

python3 "$compiler" "$tmpdir/source" --agent codex --output "$tmpdir/out" >/tmp/cutiepie-compile-update.log
marker_count="$(grep -c '<!-- cutiepie-compile:example -->' "$tmpdir/out/AGENTS.md")"
if [ "$marker_count" -eq 1 ]; then
  printf '[PASS] Codex section updates in place\n'
else
  printf '[FAIL] Codex section duplicated on update\n'
  failures=$((failures + 1))
fi

if [ "$failures" -gt 0 ]; then
  cat /tmp/cutiepie-compile.log
  exit 1
fi
