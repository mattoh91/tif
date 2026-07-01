#!/usr/bin/env bash
# Run the slide-deck (story_007) Node unit/integration tests.
set -euo pipefail
cd "$(git rev-parse --show-toplevel)"
exec node --test tests/deck/*.test.mjs
