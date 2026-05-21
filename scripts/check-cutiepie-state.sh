#!/usr/bin/env bash
set -euo pipefail

root="${1:-.}"
docs_dir="${root}/.cutiepie/docs"
status=0

emit() {
  local severity="$1"
  local message="$2"
  printf -- '- [%s] %s\n' "$severity" "$message"
  case "$severity" in
    missing|blocked|invalid)
      status=1
      ;;
  esac
}

if [ ! -d "$docs_dir" ]; then
  emit "missing" "Expected canonical Cutiepie docs directory: ${docs_dir}"
fi

for doc in PRD.md feature_list.json ARD.md ARCHI.md CONFIG.md PLAN.md; do
  if [ ! -f "${docs_dir}/${doc}" ]; then
    emit "missing" "Cutiepie artifact is missing: ${docs_dir}/${doc}"
  fi
done

for legacy in \
  "${root}/.cutiepie/FRD.md" \
  "${root}/.cutiepie/CAVEATS.md" \
  "${root}/docs/cutiepie/FRD.md" \
  "${root}/docs/cutiepie/CAVEATS.md"; do
  if [ -f "$legacy" ]; then
    emit "warning" "Legacy Cutiepie artifact exists outside canonical ownership: ${legacy}"
  fi
done

if [ -f "${docs_dir}/feature_list.json" ]; then
  set +e
  node - "$root" <<'NODE'
const fs = require('fs');
const path = require('path');

const root = process.argv[2];
const docsDir = path.join(root, '.cutiepie', 'docs');
const featurePath = path.join(docsDir, 'feature_list.json');
const planPath = path.join(docsDir, 'PLAN.md');
let status = 0;

function emit(severity, message) {
  console.log(`- [${severity}] ${message}`);
  if (['missing', 'blocked', 'invalid'].includes(severity)) {
    status = 1;
  }
}

function readJson(file) {
  try {
    return JSON.parse(fs.readFileSync(file, 'utf8'));
  } catch (error) {
    emit('invalid', `${file} is not valid JSON: ${error.message}`);
    return null;
  }
}

const raw = readJson(featurePath);
if (!raw) {
  process.exit(status);
}

const features = Array.isArray(raw) ? raw : raw.features;
if (!Array.isArray(features)) {
  emit('invalid', `${featurePath} must contain a top-level features array or be an array of features.`);
  process.exit(status);
}

if (Array.isArray(raw)) {
  emit('warning', `${featurePath} uses legacy bare-array shape; prefer an object with schema_version, scope, and features.`);
}

const seen = new Set();
const ids = [];
const phases = new Map();
let comprehensiveCount = 0;

features.forEach((feature, index) => {
  const label = feature && feature.id ? feature.id : `feature[${index}]`;

  if (!feature || typeof feature !== 'object' || Array.isArray(feature)) {
    emit('invalid', `feature[${index}] must be an object.`);
    return;
  }

  for (const field of ['id', 'category', 'description', 'steps', 'references', 'implementation_phase', 'passes']) {
    if (!(field in feature)) {
      emit('invalid', `${label} is missing required field: ${field}`);
    }
  }

  if (typeof feature.id === 'string' && feature.id.trim()) {
    if (seen.has(feature.id)) {
      emit('invalid', `Duplicate feature id: ${feature.id}`);
    }
    seen.add(feature.id);
    ids.push(feature.id);
  } else {
    emit('invalid', `feature[${index}] id must be a non-empty string.`);
  }

  if (!['functional', 'style'].includes(feature.category)) {
    emit('invalid', `${label} category must be "functional" or "style".`);
  }

  if (typeof feature.description !== 'string' || !feature.description.trim()) {
    emit('invalid', `${label} description must be a non-empty string.`);
  }

  if (!Array.isArray(feature.steps) || feature.steps.length === 0) {
    emit('invalid', `${label} steps must be a non-empty array.`);
  } else {
    if (feature.steps.length >= 10) {
      comprehensiveCount += 1;
    }
    feature.steps.forEach((step, stepIndex) => {
      if (typeof step !== 'string' || !/^Step\s+\d+:/i.test(step.trim())) {
        emit('invalid', `${label} step ${stepIndex + 1} must start with "Step N:".`);
      }
    });
  }

  if (!Array.isArray(feature.references)) {
    emit('invalid', `${label} references must be an array.`);
  }

  if (!Number.isInteger(feature.implementation_phase) || feature.implementation_phase < 1) {
    emit('invalid', `${label} implementation_phase must be a positive integer.`);
  } else {
    const group = phases.get(feature.implementation_phase) || [];
    group.push(feature);
    phases.set(feature.implementation_phase, group);
  }

  if (typeof feature.passes !== 'boolean') {
    emit('invalid', `${label} passes must be a boolean.`);
  }
});

const waivers = Array.isArray(raw?.scope?.waivers) ? raw.scope.waivers : [];
const hasComprehensiveWaiver = waivers.some((waiver) => waiver && waiver.rule === 'minimum_25_comprehensive_tests');
if (comprehensiveCount < 25 && !hasComprehensiveWaiver) {
  emit('blocked', `${featurePath} has ${comprehensiveCount} comprehensive features with 10+ steps; add a scope waiver from feature-list-builder for tiny/backend-only projects or expand coverage to at least 25.`);
}

if (fs.existsSync(planPath)) {
  const planLines = fs.readFileSync(planPath, 'utf8').split(/\r?\n/);
  const featureIdPattern = ids.length > 0
    ? new RegExp(`\\b(?:${ids.map((id) => id.replace(/[.*+?^${}()|[\]\\]/g, '\\$&')).join('|')})\\b`)
    : /\bF\d{3,}\b/;

  planLines.forEach((line, index) => {
    const checked = /^\s*[-*]\s*\[[xX]\]/.test(line);
    if (!checked) {
      return;
    }

    if (featureIdPattern.test(line) || /\bpasses\b/.test(line)) {
      emit('blocked', `${planPath}:${index + 1} duplicates feature completion state; PLAN.md may track workflow phases only. Keep feature pass/fail state in feature_list.json.`);
    }

    const phaseMatch = line.match(/\bphase\s+(\d+)\b/i);
    if (!phaseMatch) {
      return;
    }

    const phase = Number.parseInt(phaseMatch[1], 10);
    const isCompletionLine = /feature checks|implementation complete|phase complete|complete/i.test(line);
    if (!isCompletionLine) {
      return;
    }

    for (const prior of [...phases.keys()].filter((candidate) => candidate < phase).sort((a, b) => a - b)) {
      const failing = phases.get(prior).filter((feature) => feature.passes !== true).map((feature) => feature.id);
      if (failing.length > 0) {
        emit('blocked', `${planPath}:${index + 1} marks phase ${phase} progress before phase ${prior} passes all features: ${failing.join(', ')}`);
      }
    }

    if (/feature checks|phase complete|complete/i.test(line)) {
      const current = phases.get(phase) || [];
      const failing = current.filter((feature) => feature.passes !== true).map((feature) => feature.id);
      if (current.length > 0 && failing.length > 0) {
        emit('blocked', `${planPath}:${index + 1} marks phase ${phase} complete, but these features do not pass: ${failing.join(', ')}`);
      }
    }
  });
}

process.exit(status);
NODE
  node_status=$?
  set -e
  if [ "$node_status" -ne 0 ]; then
    status=1
  fi
fi

if [ "$status" -eq 0 ]; then
  printf -- '- [ok] Cutiepie state contract is mechanically valid.\n'
fi

exit "$status"
