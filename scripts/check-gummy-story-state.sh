#!/usr/bin/env bash
set -euo pipefail

script_dir="$(cd "$(dirname "$0")" && pwd)"
"${script_dir}/check-gummy-state.sh" "${1:-.}"
