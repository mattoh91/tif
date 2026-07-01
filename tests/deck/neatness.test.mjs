import { test } from 'node:test';
import assert from 'node:assert/strict';
import { runNeatnessChecks } from '../../scripts/deck/neatness.mjs';

// Clean scene: two nodes, one edge landing exactly on both boundaries.
function cleanScene() {
  return {
    viewport: { width: 400, height: 200 },
    nodes: [
      { id: 'n1', label: 'Client', rect: { x: 0, y: 0, w: 100, h: 50 } },
      { id: 'n2', label: 'API', rect: { x: 200, y: 0, w: 100, h: 50 } },
    ],
    edges: [
      { id: 'e1', source: 'n1', target: 'n2', tail: { x: 100, y: 25 }, head: { x: 200, y: 25 } },
    ],
  };
}

const OPTS = { tol: 3, minGap: 20, maxCrossings: 0 };

function check(report, id) {
  return report.checks.find((c) => c.id === id);
}

test('a clean scene is accepted with all checks passing', () => {
  const r = runNeatnessChecks(cleanScene(), OPTS);
  assert.equal(r.accepted, true);
  assert.ok(r.checks.every((c) => c.passed), 'all checks should pass');
});

test('overlapping shapes is a hard failure', () => {
  const s = cleanScene();
  s.nodes[1].rect = { x: 50, y: 0, w: 100, h: 50 }; // overlaps n1
  const r = runNeatnessChecks(s, OPTS);
  assert.equal(check(r, 'overlapping-shapes').severity, 'fail');
  assert.equal(check(r, 'overlapping-shapes').passed, false);
  assert.equal(r.accepted, false);
});

test('an off-canvas node is a hard failure', () => {
  const s = cleanScene();
  s.nodes[1].rect = { x: 350, y: 0, w: 100, h: 50 }; // bleeds past width 400
  const r = runNeatnessChecks(s, OPTS);
  assert.equal(check(r, 'off-canvas').passed, false);
  assert.equal(r.accepted, false);
});

test('an arrow head not landing on its target is a hard failure', () => {
  const s = cleanScene();
  s.edges[0].head = { x: 150, y: 25 }; // floats in empty space, far from n2
  const r = runNeatnessChecks(s, OPTS);
  assert.equal(check(r, 'mislanded-arrows').passed, false);
  assert.equal(r.accepted, false);
});

test('an edge referencing a missing node is a dangling hard failure', () => {
  const s = cleanScene();
  s.edges[0].target = 'ghost';
  const r = runNeatnessChecks(s, OPTS);
  assert.equal(check(r, 'mislanded-arrows').passed, false);
  assert.match(check(r, 'mislanded-arrows').detail, /ghost|dangling|missing/i);
  assert.equal(r.accepted, false);
});

test('excessive edge crossings is a warning, not a block', () => {
  const s = cleanScene();
  s.nodes.push({ id: 'n3', label: 'A', rect: { x: 0, y: 120, w: 100, h: 50 } });
  s.nodes.push({ id: 'n4', label: 'B', rect: { x: 200, y: 120, w: 100, h: 50 } });
  // Two edges that cross each other.
  s.edges = [
    { id: 'e1', source: 'n1', target: 'n4', tail: { x: 50, y: 50 }, head: { x: 250, y: 120 } },
    { id: 'e2', source: 'n3', target: 'n2', tail: { x: 50, y: 120 }, head: { x: 250, y: 50 } },
  ];
  const r = runNeatnessChecks(s, OPTS);
  assert.equal(check(r, 'edge-crossings').severity, 'warn');
  assert.equal(check(r, 'edge-crossings').passed, false);
  assert.equal(r.accepted, true, 'warnings must not block acceptance');
});

test('nodes closer than the minimum gap is a warning', () => {
  const s = cleanScene();
  s.nodes[1].rect = { x: 105, y: 0, w: 100, h: 50 }; // 5px gap < minGap 20
  s.edges[0].head = { x: 105, y: 25 };
  const r = runNeatnessChecks(s, OPTS);
  assert.equal(check(r, 'node-spacing').severity, 'warn');
  assert.equal(check(r, 'node-spacing').passed, false);
  assert.equal(r.accepted, true);
});

test('an edge routed through an unrelated node is a warning', () => {
  const s = cleanScene();
  s.nodes.push({ id: 'n3', label: 'Mid', rect: { x: 130, y: 10, w: 40, h: 30 } });
  // e1 still n1->n2 but its straight path crosses n3 sitting in the middle.
  const r = runNeatnessChecks(s, OPTS);
  assert.equal(check(r, 'edge-through-unrelated-node').severity, 'warn');
  assert.equal(check(r, 'edge-through-unrelated-node').passed, false);
  assert.equal(r.accepted, true);
});
