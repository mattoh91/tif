#!/usr/bin/env bash
set -euo pipefail

root="${1:-.}"

missing=0
for doc in PRD.md FRD.md ARD.md CAVEATS.md ARCHI.md PLAN.md; do
  if [ ! -f "${root}/.sweet/${doc}" ] && [ ! -f "${root}/docs/sweet/${doc}" ]; then
    printf 'missing %s: expected %s/.sweet/%s or %s/docs/sweet/%s\n' "$doc" "$root" "$doc" "$root" "$doc" >&2
    printf '  note: dated archives under docs/sweet/specs, docs/sweet/plans, or docs/plans do not satisfy the active Sweet spec-set gate\n' >&2
    missing=1
  fi
done

if [ "$missing" -ne 0 ]; then
  exit 1
fi

printf 'Sweet spec set complete under %s\n' "$root"
