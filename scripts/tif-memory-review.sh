#!/usr/bin/env bash
set -euo pipefail

action="${1:-list}"
candidate_id="${2:-}"

if [ "$action" != "list" ] && [ "$action" != "--approve" ] && [ "$action" != "--reject" ]; then
  printf 'Usage: %s [--approve <candidate-id> | --reject <candidate-id>]\n' "$0" >&2
  exit 2
fi

if { [ "$action" = "--approve" ] || [ "$action" = "--reject" ]; } && [ -z "$candidate_id" ]; then
  printf 'Missing candidate id.\n' >&2
  exit 2
fi

node - "$action" "$candidate_id" <<'NODE'
const fs = require('fs');
const os = require('os');
const path = require('path');
const crypto = require('crypto');
const childProcess = require('child_process');

const action = process.argv[2];
const candidateId = process.argv[3];

function projectSlug() {
  try {
    const remote = childProcess.execFileSync('git', ['remote', 'get-url', 'origin'], { encoding: 'utf8', stdio: ['ignore', 'pipe', 'ignore'] }).trim();
    if (remote) {
      return remote
        .replace(/^[a-zA-Z]+:\/\//, '')
        .replace(/^git@/, '')
        .replace(':', '/')
        .replace(/\.git$/, '')
        .replace(/[^A-Za-z0-9._/-]+/g, '-')
        .replace(/[\/]+/g, '-')
        .toLowerCase();
    }
  } catch (_) {
    // Fall back to the local directory name.
  }
  return path.basename(process.cwd()).toLowerCase().replace(/[^a-z0-9._-]+/g, '-');
}

function readCandidates(file) {
  if (!fs.existsSync(file)) {
    return [];
  }
  return fs.readFileSync(file, 'utf8')
    .split(/\r?\n/)
    .filter(Boolean)
    .map((line, index) => {
      try {
        return JSON.parse(line);
      } catch (error) {
        throw new Error(`${file}:${index + 1} is not valid JSON: ${error.message}`);
      }
    });
}

function writeCandidates(file, candidates) {
  fs.mkdirSync(path.dirname(file), { recursive: true });
  const body = candidates.map((candidate) => JSON.stringify(candidate)).join('\n');
  fs.writeFileSync(file, body ? `${body}\n` : '');
}

function riskReasons(candidate) {
  const reasons = [];
  const text = JSON.stringify(candidate);
  const secretPattern = /(api[_-]?key|password|passwd|secret|token|BEGIN [A-Z ]*PRIVATE KEY|sk-[A-Za-z0-9_-]{20,})/i;
  if (secretPattern.test(text)) {
    reasons.push('possible_secret');
  }
  for (const flag of candidate.risk_flags || []) {
    if (['secret', 'untrusted_instruction', 'cross_project_assumption', 'raw_transcript'].includes(flag)) {
      reasons.push(flag);
    }
  }
  return [...new Set(reasons)];
}

function verificationResult(command) {
  if (!command) {
    return 'skipped: no verification command';
  }
  try {
    childProcess.execSync(command, { stdio: 'pipe', shell: true });
    return `passed: ${command}`;
  } catch (error) {
    return `failed: ${command}`;
  }
}

function appendLesson(memoryDir, candidate) {
  const target = candidate.target === 'failure' ? 'FAILURES.md' : 'MEMORY.md';
  const file = path.join(memoryDir, target);
  const now = new Date().toISOString();
  const source = candidate.source || {};
  const verification = candidate.verification || {};
  const body = [
    '',
    `## ${now} - ${candidate.id}`,
    '',
    `- Source: ${source.type || 'unknown'} ${source.path || ''}`.trim(),
    `- Proposal: ${candidate.proposal || '(empty)'}`,
    `- Verification: ${verification.result || 'pending'}`,
    '',
  ].join('\n');
  fs.mkdirSync(memoryDir, { recursive: true });
  if (!fs.existsSync(file)) {
    fs.writeFileSync(file, target === 'FAILURES.md' ? '# Tif Failure Modes\n' : '# Tif Memory\n');
  }
  fs.appendFileSync(file, body);
  return file;
}

const slug = projectSlug();
const memoryDir = path.join(os.homedir(), '.tif', 'memory', slug);
const candidatesFile = path.join(memoryDir, 'CANDIDATES.jsonl');
const candidates = readCandidates(candidatesFile);

if (action === 'list') {
  const pending = candidates.filter((candidate) => candidate.status === 'pending' || candidate.status === 'requires-user-review');
  if (pending.length === 0) {
    console.log(`No pending Tif memory candidates in ${candidatesFile}.`);
  } else {
    console.log(`Pending Tif memory candidates in ${candidatesFile}:`);
    for (const candidate of pending) {
      console.log(`- ${candidate.id} [${candidate.status}] target=${candidate.target} risk=${(candidate.risk_flags || []).join(',') || 'none'}`);
      console.log(`  proposal: ${candidate.proposal || '(empty)'}`);
      if (candidate.source && candidate.source.excerpt) {
        console.log(`  source: ${candidate.source.excerpt}`);
      }
    }
  }
  process.exit(0);
}

const candidate = candidates.find((item) => item.id === candidateId);
if (!candidate) {
  console.error(`Candidate not found: ${candidateId}`);
  process.exit(1);
}

if (action === '--reject') {
  candidate.status = 'rejected';
  candidate.rejected_at = new Date().toISOString();
  writeCandidates(candidatesFile, candidates);
  console.log(`Rejected ${candidateId}.`);
  process.exit(0);
}

const risks = riskReasons(candidate);
if (risks.length > 0 && process.env.TIF_ALLOW_RISKY_MEMORY !== '1') {
  candidate.status = 'requires-user-review';
  candidate.risk_flags = [...new Set([...(candidate.risk_flags || []), ...risks])];
  writeCandidates(candidatesFile, candidates);
  console.error(`Refusing to promote ${candidateId}; risk flags require manual review: ${risks.join(', ')}`);
  process.exit(1);
}

if (!['memory', 'failure'].includes(candidate.target)) {
  candidate.status = 'approved';
  candidate.approved_at = new Date().toISOString();
  candidate.promotion_note = 'Manual patch required for non-memory target.';
  writeCandidates(candidatesFile, candidates);
  console.log(`Approved ${candidateId}; apply the ${candidate.target} patch manually and run its verification command.`);
  process.exit(0);
}

candidate.verification = candidate.verification || {};
candidate.verification.result = verificationResult(candidate.verification.command || 'scripts/check-tif-state.sh .');
const targetFile = appendLesson(memoryDir, candidate);
candidate.status = 'promoted';
candidate.promoted_at = new Date().toISOString();
candidate.promoted_to = targetFile;
writeCandidates(candidatesFile, candidates);
console.log(`Promoted ${candidateId} to ${targetFile}.`);
console.log(candidate.verification.result);
NODE
