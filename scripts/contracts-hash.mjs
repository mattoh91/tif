// Content hash of a story's spec contract declarations (story_010 spec_002).
// Staleness of contracts.json is judged by this hash, not file mtime — editing
// non-contract spec fields (e.g. `passes`) must not trip a staleness warning.
//
// The state checker inlines the SAME formula; this module is the single source
// of truth used by `contract-designer` (to write spec_contracts_sha) and tests.

import fs from 'node:fs';
import path from 'node:path';
import { createHash } from 'node:crypto';

// specs: [{ spec_id, contracts: { provides, consumes } }]
export function specContractsHash(specs) {
  const lines = [...specs]
    .sort((a, b) => (a.spec_id < b.spec_id ? -1 : a.spec_id > b.spec_id ? 1 : 0))
    .map((s) => {
      const c = s.contracts || {};
      const provides = [...(c.provides || [])].sort().join(',');
      const consumes = [...(c.consumes || [])].sort().join(',');
      return `${s.spec_id}|${provides}|${consumes}`;
    });
  return createHash('sha256').update(lines.join('\n'), 'utf8').digest('hex');
}

function parseSpecContracts(file) {
  const fm = fs.readFileSync(file, 'utf8').match(/^---\n([\s\S]*?)\n---/);
  const body = fm ? fm[1] : '';
  const spec_id = (body.match(/(^|\n)spec_id:\s*(\S+)/) || [])[2] || path.basename(file);
  const list = (name) => {
    // inline form: `  provides: [a, b]`
    const inline = body.match(new RegExp(`\\n  ${name}:\\s*\\[([^\\]]*)\\]`));
    if (inline) return inline[1].split(',').map((s) => s.trim()).filter(Boolean);
    // block form under `contracts:` → `  provides:\n    - a`
    const block = body.match(new RegExp(`\\n  ${name}:\\s*\\n([\\s\\S]*?)(?=\\n  \\S|$)`));
    if (block) return block[1].split(/\r?\n/).map((l) => (l.match(/^\s*-\s*(.+)$/) || [])[1]).filter(Boolean);
    return [];
  };
  return { spec_id, contracts: { provides: list('provides'), consumes: list('consumes') } };
}

export function hashStoryDir(storyDir) {
  const specsDir = path.join(storyDir, 'specs');
  if (!fs.existsSync(specsDir)) return specContractsHash([]);
  const specs = fs.readdirSync(specsDir)
    .filter((n) => /^spec_\d{3}_.*\.md$/.test(n))
    .map((n) => parseSpecContracts(path.join(specsDir, n)));
  return specContractsHash(specs);
}

// CLI: node scripts/contracts-hash.mjs <storyDir>  → prints the hash
if (import.meta.url === `file://${process.argv[1]}`) {
  const dir = process.argv[2];
  if (!dir) {
    console.error('usage: contracts-hash.mjs <storyDir>');
    process.exit(2);
  }
  console.log(hashStoryDir(dir));
}
