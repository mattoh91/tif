import { test } from 'node:test';
import assert from 'node:assert/strict';
import { specContractsHash } from '../../scripts/contracts-hash.mjs';

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
