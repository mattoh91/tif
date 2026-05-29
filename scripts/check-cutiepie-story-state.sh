#!/usr/bin/env bash
set -euo pipefail

script_dir="$(cd "$(dirname "$0")" && pwd)"
"${script_dir}/check-cutiepie-state.sh" "${1:-.}"
