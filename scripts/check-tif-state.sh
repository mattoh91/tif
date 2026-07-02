#!/usr/bin/env bash
set -euo pipefail

root="${1:-.}"
script_dir="$(cd "$(dirname "$0")" && pwd)"
core_status=0

node - "$root" <<'NODE' || core_status=$?
const fs = require('fs');
const path = require('path');
const crypto = require('crypto');

const root = process.argv[2];
const docsDir = path.join(root, '.tif', 'docs');
const plansDir = path.join(root, '.tif', 'plans');
let status = 0;

function emit(severity, message) {
  console.log(`- [${severity}] ${message}`);
  if (['missing', 'blocked', 'invalid'].includes(severity)) {
    status = 1;
  }
}

function exists(file) {
  return fs.existsSync(file);
}

function read(file) {
  return fs.readFileSync(file, 'utf8');
}

function cleanValue(value) {
  return value.trim().replace(/^['"]|['"]$/g, '');
}

function parseInlineList(value) {
  const trimmed = value.trim();
  if (!trimmed.startsWith('[') || !trimmed.endsWith(']')) {
    return null;
  }
  const body = trimmed.slice(1, -1).trim();
  if (!body) {
    return [];
  }
  return body.split(',').map((part) => cleanValue(part)).filter(Boolean);
}

function parseFrontmatter(file) {
  const text = read(file);
  const match = text.match(/^---\r?\n([\s\S]*?)\r?\n---/);
  if (!match) {
    emit('invalid', `${file} must start with YAML frontmatter.`);
    return null;
  }

  const meta = {
    story_id: '',
    spec_id: '',
    title: '',
    completed: null,
    depends_on: [],
    contracts: { provides: [], consumes: [] },
    acceptance_checks: [],
  };

  let section = null;
  let activeCheck = null;
  let inSteps = false;

  for (const rawLine of match[1].split(/\r?\n/)) {
    const line = rawLine.replace(/\s+$/, '');
    if (!line.trim()) {
      continue;
    }

    const top = line.match(/^([A-Za-z_][A-Za-z0-9_]*):\s*(.*)$/);
    if (top) {
      const [, key, rawValue] = top;
      const value = cleanValue(rawValue);
      section = key;
      inSteps = false;
      if (key === 'story_id' || key === 'spec_id' || key === 'title') {
        meta[key] = value;
      } else if (key === 'completed') {
        meta.completed = value === 'true' ? true : value === 'false' ? false : null;
      } else if (key === 'depends_on') {
        const inline = parseInlineList(rawValue);
        meta.depends_on = inline || [];
      } else if (key !== 'contracts' && key !== 'acceptance_checks') {
        meta[key] = value;
      }
      continue;
    }

    if (section === 'depends_on') {
      const item = line.match(/^\s*-\s*(.+)$/);
      if (item) {
        meta.depends_on.push(cleanValue(item[1]));
      }
      continue;
    }

    const contractList = line.match(/^\s{2}(provides|consumes):\s*(.*)$/);
    if (section && section.startsWith('contracts') && contractList) {
      const [, listName, rawValue] = contractList;
      section = `contracts.${listName}`;
      const inline = parseInlineList(rawValue);
      if (inline) {
        meta.contracts[listName] = inline;
      }
      continue;
    }

    const contractItem = line.match(/^\s*-\s*(.+)$/);
    if (section === 'contracts.provides' && contractItem) {
      meta.contracts.provides.push(cleanValue(contractItem[1]));
      continue;
    }
    if (section === 'contracts.consumes' && contractItem) {
      meta.contracts.consumes.push(cleanValue(contractItem[1]));
      continue;
    }

    if (section === 'acceptance_checks') {
      const checkStart = line.match(/^\s*-\s*id:\s*(.+)$/);
      if (checkStart) {
        activeCheck = {
          id: cleanValue(checkStart[1]),
          category: '',
          description: '',
          steps: [],
          passes: null,
        };
        meta.acceptance_checks.push(activeCheck);
        inSteps = false;
        continue;
      }
    }

    if (activeCheck) {
      const attr = line.match(/^\s{4}([A-Za-z_][A-Za-z0-9_]*):\s*(.*)$/);
      if (attr) {
        const [, key, rawValue] = attr;
        const value = cleanValue(rawValue);
        if (key === 'category' || key === 'description') {
          activeCheck[key] = value;
        } else if (key === 'passes') {
          activeCheck.passes = value === 'true' ? true : value === 'false' ? false : null;
        } else if (key === 'steps') {
          inSteps = true;
        }
        continue;
      }

      if (inSteps) {
        const step = line.match(/^\s*-\s*(.+)$/);
        if (step) {
          activeCheck.steps.push(cleanValue(step[1]));
        }
      }
    }
  }

  return meta;
}

function validateSpec(file, storyId) {
  const meta = parseFrontmatter(file);
  if (!meta) {
    return null;
  }

  const label = `${storyId}/${path.basename(file)}`;
  if (meta.story_id !== storyId) {
    emit('invalid', `${label} story_id must be ${storyId}.`);
  }
  if (!/^spec_\d{3}$/.test(meta.spec_id)) {
    emit('invalid', `${label} spec_id must look like spec_001.`);
  }
  if (!meta.title) {
    emit('invalid', `${label} title is required.`);
  }
  if (typeof meta.completed !== 'boolean') {
    emit('invalid', `${label} completed must be true or false.`);
  }
  if (!Array.isArray(meta.depends_on)) {
    emit('invalid', `${label} depends_on must be a list.`);
  }
  if (!Array.isArray(meta.contracts.provides) || !Array.isArray(meta.contracts.consumes)) {
    emit('invalid', `${label} contracts.provides and contracts.consumes must be lists.`);
  }
  if (!Array.isArray(meta.acceptance_checks) || meta.acceptance_checks.length === 0) {
    emit('invalid', `${label} must define acceptance_checks.`);
  }

  meta.acceptance_checks.forEach((check, index) => {
    const checkLabel = `${label} acceptance_checks[${index}]`;
    if (!check.id) {
      emit('invalid', `${checkLabel} id is required.`);
    }
    if (!['functional', 'integration', 'e2e', 'style', 'security'].includes(check.category)) {
      emit('invalid', `${checkLabel} category must be functional or style.`);
    }
    if (!check.description) {
      emit('invalid', `${checkLabel} description is required.`);
    }
    if (!Array.isArray(check.steps) || check.steps.length === 0) {
      emit('invalid', `${checkLabel} steps must be non-empty.`);
    }
    check.steps.forEach((step, stepIndex) => {
      if (!/^Step\s+\d+:/i.test(step)) {
        emit('invalid', `${checkLabel} step ${stepIndex + 1} must start with "Step N:".`);
      }
    });
    if (typeof check.passes !== 'boolean') {
      emit('invalid', `${checkLabel} passes must be true or false.`);
    }
  });

  if (meta.completed === true && meta.acceptance_checks.some((check) => check.passes !== true)) {
    emit('blocked', `${label} is completed but not all acceptance checks pass.`);
  }

  return meta;
}

function validateAcyclic(specsById, storyLabel) {
  const visiting = new Set();
  const visited = new Set();

  function visit(specId, stack) {
    if (visited.has(specId)) {
      return;
    }
    if (visiting.has(specId)) {
      emit('blocked', `${storyLabel} spec dependencies contain a cycle: ${[...stack, specId].join(' -> ')}`);
      return;
    }
    visiting.add(specId);
    const spec = specsById.get(specId);
    for (const dependency of spec.depends_on) {
      if (!specsById.has(dependency)) {
        emit('invalid', `${storyLabel}/${specId} depends on missing spec ${dependency}.`);
        continue;
      }
      visit(dependency, [...stack, specId]);
    }
    visiting.delete(specId);
    visited.add(specId);
  }

  for (const specId of specsById.keys()) {
    visit(specId, []);
  }
}

function validateContracts(file, storyId, specsById, storyDir, globalProvided, dagMap) {
  globalProvided = globalProvided || new Map();
  dagMap = dagMap || {};
  let raw;
  try {
    raw = JSON.parse(read(file));
  } catch (error) {
    emit('invalid', `${file} is not valid JSON: ${error.message}`);
    return;
  }

  if (raw.schema_version !== 'tif.contracts.v1') {
    emit('invalid', `${file} schema_version must be tif.contracts.v1.`);
  }
  if (raw.story_id !== storyId) {
    emit('invalid', `${file} story_id must be ${storyId}.`);
  }
  if (!Array.isArray(raw.contracts)) {
    emit('invalid', `${file} contracts must be an array.`);
    return;
  }

  const ids = new Set();
  const providedBySpec = new Map();
  for (const contract of raw.contracts) {
    if (!contract || typeof contract !== 'object') {
      emit('invalid', `${file} contains a non-object contract.`);
      continue;
    }
    if (!contract.id) {
      emit('invalid', `${file} contract is missing id.`);
      continue;
    }
    if (ids.has(contract.id)) {
      emit('invalid', `${file} has duplicate contract id ${contract.id}.`);
    }
    ids.add(contract.id);

    if (!contract.provider || !specsById.has(contract.provider)) {
      emit('invalid', `${file} contract ${contract.id} has missing provider spec ${contract.provider || '(empty)'}.`);
    } else {
      const existing = providedBySpec.get(contract.id);
      if (existing && existing !== contract.provider) {
        emit('invalid', `${file} contract ${contract.id} has multiple providers: ${existing}, ${contract.provider}.`);
      }
      providedBySpec.set(contract.id, contract.provider);
    }

    if (!Array.isArray(contract.consumers)) {
      emit('invalid', `${file} contract ${contract.id} consumers must be an array.`);
    } else {
      for (const consumer of contract.consumers) {
        if (!specsById.has(consumer)) {
          emit('invalid', `${file} contract ${contract.id} has missing consumer spec ${consumer}.`);
        }
      }
    }
  }

  const external = new Set((raw.external_contracts || []).map((contract) => contract.id || contract));

  // Cross-story upstream references (story_010 spec_004): an external contract
  // may declare `upstream: "story_nnn/spec_nnn"`. It must actually provide the
  // id, and this story must depend on the upstream story in the PRD story_dag.
  for (const ext of (raw.external_contracts || [])) {
    if (!ext || typeof ext !== 'object' || !ext.upstream) continue;
    const um = String(ext.upstream).match(/^(story_\d{3})\/(spec_\d{3})$/);
    if (!um) {
      emit('invalid', `${file} external contract ${ext.id} has malformed upstream "${ext.upstream}" (expected story_nnn/spec_nnn).`);
      continue;
    }
    if (!(globalProvided.get(ext.id) || []).includes(`${um[1]}/${um[2]}`)) {
      emit('invalid', `${file} upstream ${ext.upstream} does not provide contract ${ext.id}.`);
    }
    if (!(dagMap[storyId] || []).includes(um[1])) {
      emit('invalid', `${file} upstream contract ${ext.id} needs a PRD story_dag edge ${storyId} -> ${um[1]}.`);
    }
  }

  for (const [specId, spec] of specsById.entries()) {
    for (const provided of spec.contracts.provides) {
      if (!ids.has(provided)) {
        emit('invalid', `${storyId}/${specId} provides ${provided}, but contracts.json does not define it.`);
      }
    }
    for (const consumed of spec.contracts.consumes) {
      if (!ids.has(consumed) && !external.has(consumed)) {
        emit('invalid', `${storyId}/${specId} consumes ${consumed}, but contracts.json does not define it or mark it external.`);
      }
    }
  }

  // Staleness by content hash of spec contract declarations (story_010 spec_002),
  // NOT mtime: editing non-contract fields (e.g. passes) must not trip it.
  // Formula mirrors scripts/contracts-hash.mjs (single source of truth).
  const specHash = crypto.createHash('sha256').update(
    [...specsById.values()]
      .sort((a, b) => (a.spec_id < b.spec_id ? -1 : a.spec_id > b.spec_id ? 1 : 0))
      .map((m) => {
        const c = m.contracts || {};
        return `${m.spec_id}|${[...(c.provides || [])].sort().join(',')}|${[...(c.consumes || [])].sort().join(',')}`;
      })
      .join('\n'),
    'utf8',
  ).digest('hex');
  if (raw.spec_contracts_sha && raw.spec_contracts_sha !== specHash) {
    emit('warning', `${file} may be stale; spec provides/consumes changed since contracts.json (spec_contracts_sha mismatch).`);
  }
}

if (!exists(docsDir)) {
  emit('missing', `Expected Tif docs directory: ${docsDir}`);
}

for (const doc of ['PRD.md', 'ARCHI.md', 'CONFIG.md']) {
  const file = path.join(docsDir, doc);
  if (!exists(file)) {
    emit('missing', `Tif doc is missing: ${file}`);
  }
}

if (!exists(plansDir)) {
  emit('missing', `Expected Tif story plans directory: ${plansDir}`);
} else {
  const storyDirs = fs.readdirSync(plansDir)
    .filter((name) => fs.statSync(path.join(plansDir, name)).isDirectory())
    .filter((name) => /^story_\d{3}_[a-z0-9][a-z0-9_-]*$/.test(name))
    .sort();

  if (storyDirs.length === 0) {
    emit('missing', `${plansDir} must contain at least one story_<nnn>_<slug> directory after planning.`);
  }

  let totalStories = 0;
  let completeStories = 0;
  let incompleteSpecs = 0;

  // Parked stories (PRD frontmatter `parked_stories: [...]`) are exempt from the
  // specs/ADR/contracts structural requirements — planning can precede build.
  const parked = new Set();
  {
    const prdPath = path.join(docsDir, 'PRD.md');
    if (exists(prdPath)) {
      const fm = read(prdPath).match(/^---\n([\s\S]*?)\n---/);
      const m = fm && fm[1].match(/^parked_stories:\s*\[([^\]]*)\]/m);
      if (m) m[1].split(',').map((s) => s.trim()).filter(Boolean).forEach((s) => parked.add(s));
    }
  }

  // Global index of provided contracts (contractId -> ["story/spec"]) and the
  // story DAG, for validating cross-story upstream references (story_010 spec_004).
  const globalProvided = new Map();
  for (const sName of storyDirs) {
    const sId = sName.match(/^(story_\d{3})_/)[1];
    const sDir = path.join(plansDir, sName, 'specs');
    if (!exists(sDir)) continue;
    for (const f of fs.readdirSync(sDir).filter((n) => /^spec_\d{3}_.*\.md$/.test(n))) {
      const meta = parseFrontmatter(path.join(sDir, f));
      if (!meta) continue;
      for (const prov of (meta.contracts.provides || [])) {
        if (!globalProvided.has(prov)) globalProvided.set(prov, []);
        globalProvided.get(prov).push(`${sId}/${meta.spec_id}`);
      }
    }
  }
  const dagMap = {};
  {
    const prdPath = path.join(docsDir, 'PRD.md');
    if (exists(prdPath)) {
      const fmLines = (read(prdPath).match(/^---\n([\s\S]*?)\n---/) || [null, ''])[1].split(/\r?\n/);
      const start = fmLines.findIndex((l) => /^story_dag:\s*$/.test(l));
      if (start !== -1) {
        for (let i = start + 1; i < fmLines.length && /^\s+\S/.test(fmLines[i]); i++) {
          const mm = fmLines[i].match(/^\s+(story_\d{3}):\s*\[([^\]]*)\]/);
          if (mm) dagMap[mm[1]] = mm[2].split(',').map((s) => s.trim()).filter(Boolean);
        }
      }
    }
  }

  for (const storyName of storyDirs) {
    const storyDir = path.join(plansDir, storyName);
    const storyId = storyName.match(/^(story_\d{3})_/)[1];
    const adrFile = path.join(storyDir, 'ADR.md');
    const contractsFile = path.join(storyDir, 'contracts.json');
    const specsDir = path.join(storyDir, 'specs');

    if (parked.has(storyId)) {
      if (exists(adrFile)) {
        const adr = read(adrFile);
        if (!/Status:/i.test(adr) || !/Decision:/i.test(adr)) {
          emit('invalid', `${adrFile} must include Status and Decision sections.`);
        }
      }
      console.log(`- [info] ${storyName}: parked.`);
      continue;
    }

    if (!exists(specsDir)) {
      emit('missing', `${storyName} is missing specs directory.`);
      continue;
    }

    const specFiles = fs.readdirSync(specsDir)
      .filter((name) => /^spec_\d{3}_[a-z0-9][a-z0-9_-]*\.md$/.test(name))
      .sort();
    if (specFiles.length === 0) {
      emit('missing', `${specsDir} must contain spec_<nnn>_<slug>.md files.`);
      continue;
    }

    const specsById = new Map();
    let incomplete = 0;
    for (const specFile of specFiles) {
      const full = path.join(specsDir, specFile);
      const meta = validateSpec(full, storyId);
      if (!meta) {
        continue;
      }
      if (specsById.has(meta.spec_id)) {
        emit('invalid', `${storyName} has duplicate spec_id ${meta.spec_id}.`);
      }
      specsById.set(meta.spec_id, meta);
      if (meta.completed !== true) {
        incomplete += 1;
      }
    }

    // Story weight: 'spike' only when every spec opts in; absent weight = 'full'
    // (backward compatible). Spike stories may omit ADR.md and contracts.json.
    const storyWeight = specsById.size > 0 &&
      [...specsById.values()].every((m) => m.weight === 'spike') ? 'spike' : 'full';

    if (!exists(adrFile)) {
      if (storyWeight !== 'spike') {
        emit('missing', `${storyName} is missing ADR.md.`);
      }
    } else {
      const adr = read(adrFile);
      if (!/Status:/i.test(adr) || !/Decision:/i.test(adr)) {
        emit('invalid', `${adrFile} must include Status and Decision sections.`);
      }
    }

    validateAcyclic(specsById, storyName);

    if (!exists(contractsFile)) {
      if (storyWeight !== 'spike') {
        emit('missing', `${storyName} has specs but is missing contracts.json; run contract-designer before build.`);
      }
    } else {
      validateContracts(contractsFile, storyId, specsById, storyDir, globalProvided, dagMap);
    }

    totalStories += 1;
    incompleteSpecs += incomplete;
    if (incomplete === 0) completeStories += 1;
    console.log(`- [info] ${storyName}: ${specFiles.length} spec(s), ${incomplete} incomplete.`);
  }

  console.log(`- [summary] ${totalStories} stories, ${completeStories} complete, ${incompleteSpecs} specs incomplete.`);
}

// Multi-repo awareness (story_010 spec_005): warn (not fail) when .tif/ planning
// state is not under version control — common when tif runs at a container parent.
if (exists(path.join(root, '.tif'))) {
  const { execSync } = require('child_process');
  try {
    execSync(`git -C "${root}" rev-parse --is-inside-work-tree`, { stdio: 'ignore' });
    try {
      execSync(`git -C "${root}" ls-files --error-unmatch .tif`, { stdio: 'ignore' });
    } catch {
      emit('warning', `.tif/ exists but is not tracked by git — planning state is not under version control.`);
    }
  } catch {
    emit('warning', `${root} is not a git repository — .tif/ planning state is not under version control.`);
  }
}

process.exit(status);
NODE

# Story-level DAG validation (story_009): acyclic + no dangling story refs.
dag_status=0
node "$script_dir/dag/story-dag.mjs" --check "$root" || dag_status=$?

if [ "$core_status" -eq 0 ] && [ "$dag_status" -eq 0 ]; then
  echo "- [ok] Tif story state is mechanically valid."
  exit 0
fi
exit 1
