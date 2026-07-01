import { test } from 'node:test';
import assert from 'node:assert/strict';
import { readFile } from 'node:fs/promises';
import { fileURLToPath } from 'node:url';
import { parseDrawioSvg } from '../../scripts/deck/drawio-xml.mjs';

const svg = await readFile(
  fileURLToPath(new URL('./fixtures/clean-diagram.svg', import.meta.url)),
  'utf8',
);

test('extracts vertex nodes with geometry from the embedded mxGraphModel', () => {
  const { nodes } = parseDrawioSvg(svg);
  const byId = Object.fromEntries(nodes.map((n) => [n.id, n]));
  assert.deepEqual(byId.n1, { id: 'n1', label: 'Client', x: 40, y: 40, w: 120, h: 60 });
  assert.deepEqual(byId.n2, { id: 'n2', label: 'API', x: 320, y: 40, w: 120, h: 60 });
});

test('does not treat the edge cell as a node', () => {
  const { nodes } = parseDrawioSvg(svg);
  assert.equal(nodes.length, 2);
  assert.ok(!nodes.some((n) => n.id === 'e1'));
});

test('extracts edges with source and target', () => {
  const { edges } = parseDrawioSvg(svg);
  assert.deepEqual(edges, [{ id: 'e1', source: 'n1', target: 'n2' }]);
});

test('throws when the SVG carries no embedded mxGraphModel', () => {
  assert.throws(
    () => parseDrawioSvg('<svg><rect/></svg>'),
    /no embedded.*mxGraphModel/i,
  );
});
