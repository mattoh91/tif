#!/usr/bin/env bash
set -euo pipefail

echo "Initializing project..."

if [ -f package.json ]; then
  if [ -f pnpm-lock.yaml ]; then
    pnpm install
  elif [ -f yarn.lock ]; then
    yarn install
  elif [ -f package-lock.json ]; then
    npm ci
  else
    npm install
  fi
elif [ -f pyproject.toml ]; then
  if command -v uv >/dev/null 2>&1; then
    uv sync
  else
    python -m pip install -e .
  fi
elif [ -f go.mod ]; then
  go mod download
else
  echo "No known dependency manifest found. Add project setup commands to init.sh."
fi

mkdir -p .cutiepie/docs
echo "Done."
