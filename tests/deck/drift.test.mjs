import { test } from 'node:test';
import assert from 'node:assert/strict';
import { mkdtemp, writeFile, rm } from 'node:fs/promises';
import { tmpdir } from 'node:os';
import { join } from 'node:path';
import { writeDriftRef, checkDrift } from '../../scripts/deck/drift.mjs';

async function fixture() {
  const dir = await mkdtemp(join(tmpdir(), 'gummy-drift-'));
  const archi = join(dir, 'ARCHI.md');
  const ref = join(dir, '.drift.json');
  await writeFile(archi, '# Arch\nClient -> API\n');
  return { dir, archi, ref };
}

test('reports not stale immediately after writing the drift ref', async () => {
  const { dir, archi, ref } = await fixture();
  await writeDriftRef(archi, ref);
  const result = await checkDrift(archi, ref);
  assert.equal(result.stale, false);
  await rm(dir, { recursive: true, force: true });
});

test('reports stale after ARCHI.md changes', async () => {
  const { dir, archi, ref } = await fixture();
  await writeDriftRef(archi, ref);
  await writeFile(archi, '# Arch\nClient -> API -> DB\n');
  const result = await checkDrift(archi, ref);
  assert.equal(result.stale, true);
  await rm(dir, { recursive: true, force: true });
});

test('reports stale when no drift ref exists yet', async () => {
  const { dir, archi, ref } = await fixture();
  const result = await checkDrift(archi, ref);
  assert.equal(result.stale, true);
  assert.match(result.reason, /no drift ref|never/i);
  await rm(dir, { recursive: true, force: true });
});
