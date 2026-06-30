import { test } from 'node:test';
import assert from 'node:assert/strict';
import { readFile, writeFile, mkdtemp, rm } from 'node:fs/promises';
import { tmpdir } from 'node:os';
import { join } from 'node:path';
import { fileURLToPath } from 'node:url';
import { buildDeckHtml } from '../../scripts/deck/build-deck.mjs';
import { sceneFromModel, verifyDeck } from '../../scripts/deck/verify-deck.mjs';

const fx = (name) => fileURLToPath(new URL(`./fixtures/${name}`, import.meta.url));
const cleanSvg = await readFile(fx('clean-diagram.svg'), 'utf8');
const overlapSvg = await readFile(fx('overlap-diagram.svg'), 'utf8');

async function deckWith(svg) {
  const dir = await mkdtemp(join(tmpdir(), 'gummy-verify-'));
  const path = join(dir, 'deck.html');
  const html = buildDeckHtml({
    title: 'T',
    sections: [
      { id: 'overview', title: 'o', html: '<p>o</p>' },
      { id: 'value', title: 'v', html: '<p>v</p>' },
      { id: 'architecture', title: 'a', svg },
      { id: 'components', title: 'c', html: '<p>c</p>' },
    ],
  });
  await writeFile(path, html);
  return { dir, path };
}

const okProbe = async () => ({ ok: true, viewport: { width: 480, height: 120 } });
const unavailableProbe = async () => {
  const e = new Error('Cannot find package "playwright"');
  e.code = 'ERR_MODULE_NOT_FOUND';
  throw e;
};

test('sceneFromModel builds node rects and edge endpoints on the boundaries', () => {
  const scene = sceneFromModel(cleanSvg);
  assert.equal(scene.nodes.length, 2);
  assert.equal(scene.edges.length, 1);
  assert.deepEqual(scene.viewport, { width: 480, height: 120 });
  const e = scene.edges[0];
  // straight center-to-center connector exits n1's right edge (x=160) and
  // enters n2's left edge (x=320) at the shared mid-height y=70.
  assert.deepEqual(e.tail, { x: 160, y: 70 });
  assert.deepEqual(e.head, { x: 320, y: 70 });
});

test('verifyDeck skips (does not claim verified) when the browser is unavailable', async () => {
  const { dir, path } = await deckWith(cleanSvg);
  const report = await verifyDeck(path, { renderProbe: unavailableProbe });
  assert.equal(report.skipped, true);
  assert.equal(report.accepted, false);
  assert.match(report.skipped_reason, /playwright|browser|unavailable/i);
  assert.deepEqual(report.checks, []);
  await rm(dir, { recursive: true, force: true });
});

test('verifyDeck accepts a clean deck when the browser is available', async () => {
  const { dir, path } = await deckWith(cleanSvg);
  const report = await verifyDeck(path, { renderProbe: okProbe });
  assert.equal(report.skipped, false);
  assert.equal(report.accepted, true);
  await rm(dir, { recursive: true, force: true });
});

test('verifyDeck rejects a deck whose diagram has overlapping shapes', async () => {
  const { dir, path } = await deckWith(overlapSvg);
  const report = await verifyDeck(path, { renderProbe: okProbe });
  assert.equal(report.skipped, false);
  assert.equal(report.accepted, false);
  assert.ok(report.checks.find((c) => c.id === 'overlapping-shapes' && !c.passed));
  await rm(dir, { recursive: true, force: true });
});
