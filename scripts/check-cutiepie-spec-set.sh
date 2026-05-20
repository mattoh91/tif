#!/usr/bin/env bash
set -euo pipefail

root="${1:-.}"

missing=0
for doc in PRD.md FRD.md ARD.md CAVEATS.md ARCHI.md CONFIG.md PLAN.md; do
  if [ ! -f "${root}/.cutiepie/${doc}" ] && [ ! -f "${root}/docs/cutiepie/${doc}" ]; then
    printf 'missing %s: expected %s/.cutiepie/%s or %s/docs/cutiepie/%s\n' "$doc" "$root" "$doc" "$root" "$doc" >&2
    printf '  note: dated archives under docs/cutiepie/specs, docs/cutiepie/plans, or docs/plans do not satisfy the active Cutiepie spec-set gate\n' >&2
    missing=1
  fi
done

if [ "$missing" -ne 0 ]; then
  exit 1
fi

printf 'Cutiepie spec set complete under %s\n' "$root"
