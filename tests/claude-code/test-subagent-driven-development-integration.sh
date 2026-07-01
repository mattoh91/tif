#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/test-helpers.sh"
source "$SCRIPT_DIR/../tif-fixtures.sh"

echo "========================================"
echo " Integration Test: subagent-driven-development"
echo "========================================"
echo "This test executes a story-spec Tif project and may take 10-30 minutes."

TEST_PROJECT=$(create_test_project)
trap "cleanup_test_project $TEST_PROJECT" EXIT

cd "$TEST_PROJECT"

cat > package.json <<'EOF'
{
  "name": "test-project",
  "version": "1.0.0",
  "type": "module",
  "scripts": {
    "test": "node --test"
  }
}
EOF

mkdir -p src test
create_tif_docs_fixture "$TEST_PROJECT"

git init --quiet
git config user.email "test@test.com"
git config user.name "Test User"
git add .
git commit -m "Initial commit" --quiet

OUTPUT_FILE="$TEST_PROJECT/claude-output.txt"
PROMPT="Change to directory $TEST_PROJECT and execute the next incomplete Tif story spec from .tif/plans/story_001_auth_system/ using the subagent-driven-development skill. Follow contracts.json, use TDD, run acceptance checks, and update completed flags only when checks pass."

cd "$SCRIPT_DIR/../.."
run_with_timeout 1800 claude -p "$PROMPT" --allowed-tools=all --add-dir "$TEST_PROJECT" --permission-mode bypassPermissions 2>&1 | tee "$OUTPUT_FILE"

echo "Integration run complete; inspect $OUTPUT_FILE for detailed transcript."
