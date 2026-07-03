import { test } from 'node:test';
import assert from 'node:assert/strict';
import fs from 'node:fs';
import os from 'node:os';
import path from 'node:path';
import { specContractsHash, hashStoryDir, writeStoryHash } from '../../scripts/contracts-hash.mjs';

test('hash depends only on spec_id + provides + consumes', () => {
  const a = specContractsHash([
    { spec_id: 'spec_001', contracts: { provides: ['x'], consumes: [] } },
    { spec_id: 'spec_002', contracts: { provides: [], consumes: ['x'] } },
  ]);
  // reordering the input specs must not change the hash (sorted internally)
  const b = specContractsHash([
    { spec_id: 'spec_002', contracts: { provides: [], consumes: ['x'] } },
    { spec_id: 'spec_001', contracts: { provides: ['x'], consumes: [] } },
  ]);
  assert.equal(a, b);
});

test('changing provides/consumes changes the hash', () => {
  const base = specContractsHash([{ spec_id: 'spec_001', contracts: { provides: ['x'], consumes: [] } }]);
  const changed = specContractsHash([{ spec_id: 'spec_001', contracts: { provides: ['y'], consumes: [] } }]);
  assert.notEqual(base, changed);
});

test('non-contract differences do not affect the hash', () => {
  // same contracts, different (ignored) fields → identical hash
  const h1 = specContractsHash([{ spec_id: 'spec_001', contracts: { provides: ['x'], consumes: [] }, completed: false }]);
  const h2 = specContractsHash([{ spec_id: 'spec_001', contracts: { provides: ['x'], consumes: [] }, completed: true }]);
  assert.equal(h1, h2);
});

test('writeStoryHash stamps spec_contracts_sha into contracts.json in place', () => {
  const dir = fs.mkdtempSync(path.join(os.tmpdir(), 'tif-hash-'));
  try {
    const specsDir = path.join(dir, 'specs');
    fs.mkdirSync(specsDir, { recursive: true });
    fs.writeFileSync(path.join(specsDir, 'spec_001_x.md'),
      '---\nspec_id: spec_001\ncontracts:\n  provides: [a.b]\n  consumes: []\n---\nbody\n');
    const contracts = path.join(dir, 'contracts.json');
    fs.writeFileSync(contracts, JSON.stringify({ schema_version: 'tif.contracts.v1', contracts: [] }, null, 2) + '\n');

    const returned = writeStoryHash(dir);
    const written = JSON.parse(fs.readFileSync(contracts, 'utf8'));
    assert.equal(returned, hashStoryDir(dir));
    assert.equal(written.spec_contracts_sha, hashStoryDir(dir));
    // other fields are preserved
    assert.equal(written.schema_version, 'tif.contracts.v1');
  } finally {
    fs.rmSync(dir, { recursive: true, force: true });
  }
});

test('writeStoryHash throws when there is no contracts.json to stamp', () => {
  const dir = fs.mkdtempSync(path.join(os.tmpdir(), 'tif-hash-'));
  try {
    assert.throws(() => writeStoryHash(dir), /contracts\.json/);
  } finally {
    fs.rmSync(dir, { recursive: true, force: true });
  }
});
