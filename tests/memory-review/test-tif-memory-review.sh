#!/usr/bin/env bash
set -euo pipefail

script_dir="$(cd "$(dirname "$0")" && pwd)"
repo_root="$(cd "$script_dir/../.." && pwd)"
tmp_home="$(mktemp -d)"

cleanup() {
  rm -rf "$tmp_home"
}
trap cleanup EXIT

slug="$(git -C "$repo_root" remote get-url origin 2>/dev/null \
  | sed -E 's#^[a-zA-Z]+://##; s#^git@##; s#:#/#; s#\.git$##; s#[^A-Za-z0-9._/-]+#-#g; s#[/]+#-#g' \
  | tr '[:upper:]' '[:lower:]')"

if [ -z "$slug" ]; then
  slug="$(basename "$repo_root" | tr '[:upper:]' '[:lower:]' | sed -E 's#[^a-z0-9._-]+#-#g')"
fi

memory_dir="$tmp_home/.tif/memory/$slug"
mkdir -p "$memory_dir"

cat > "$memory_dir/CANDIDATES.jsonl" <<'JSONL'
{"id":"learn_test_memory","created_at":"2026-06-29T00:00:00Z","source":{"type":"test","path":"tests/memory-review","excerpt":"test candidate"},"target":"memory","scope":"project","proposal":"Remember that memory promotion is approval gated.","risk_flags":[],"status":"pending","verification":{"command":"scripts/check-tif-state.sh .","result":"pending"}}
{"id":"learn_test_secret","created_at":"2026-06-29T00:00:00Z","source":{"type":"test","path":"tests/memory-review","excerpt":"secret candidate"},"target":"memory","scope":"project","proposal":"Store API token secret in memory.","risk_flags":["secret"],"status":"pending","verification":{"command":"scripts/check-tif-state.sh .","result":"pending"}}
JSONL

HOME="$tmp_home" "$repo_root/scripts/tif-memory-review.sh" > "$tmp_home/list.txt"
grep -Fq "learn_test_memory" "$tmp_home/list.txt"

HOME="$tmp_home" "$repo_root/scripts/tif-memory-review.sh" --approve learn_test_memory > "$tmp_home/approve.txt"
grep -Fq "Promoted learn_test_memory" "$tmp_home/approve.txt"
grep -Fq "Remember that memory promotion is approval gated." "$memory_dir/MEMORY.md"
grep -Fq '"status":"promoted"' "$memory_dir/CANDIDATES.jsonl"

if HOME="$tmp_home" "$repo_root/scripts/tif-memory-review.sh" --approve learn_test_secret > "$tmp_home/secret.txt" 2>&1; then
  printf '[FAIL] risky candidate was promoted without override\n' >&2
  exit 1
fi
grep -Fq "risk flags require manual review" "$tmp_home/secret.txt"
grep -Fq '"status":"requires-user-review"' "$memory_dir/CANDIDATES.jsonl"

printf '[PASS] memory review lists, promotes safe candidates, and blocks risky candidates\n'
