#!/usr/bin/env bash
set -euo pipefail

root="${1:-.}"
script_dir="$(cd "$(dirname "$0")" && pwd)"

"${script_dir}/check-gummy-state.sh" "$root"
