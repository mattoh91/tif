import { test } from 'node:test';
import assert from 'node:assert/strict';
import {
  rectsOverlap,
  isOffCanvas,
  pointOnRectBoundary,
  segmentsIntersect,
  segmentIntersectsRect,
  rectGap,
} from '../../scripts/deck/geometry.mjs';

const A = { x: 0, y: 0, w: 100, h: 50 };

test('rectsOverlap: overlapping rectangles', () => {
  assert.equal(rectsOverlap(A, { x: 50, y: 20, w: 100, h: 50 }), true);
});

test('rectsOverlap: separated rectangles do not overlap', () => {
  assert.equal(rectsOverlap(A, { x: 200, y: 0, w: 10, h: 10 }), false);
});

test('rectsOverlap: merely touching edges is not an overlap', () => {
  assert.equal(rectsOverlap(A, { x: 100, y: 0, w: 10, h: 50 }), false);
});

test('isOffCanvas: rect within viewport is on-canvas', () => {
  assert.equal(isOffCanvas(A, { width: 200, height: 200 }), false);
});

test('isOffCanvas: rect bleeding past the right edge is off-canvas', () => {
  assert.equal(isOffCanvas({ x: 150, y: 0, w: 100, h: 10 }, { width: 200, height: 200 }), true);
});

test('isOffCanvas: negative origin is off-canvas', () => {
  assert.equal(isOffCanvas({ x: -5, y: 0, w: 10, h: 10 }, { width: 200, height: 200 }), true);
});

test('pointOnRectBoundary: a point on the edge is on the boundary', () => {
  assert.equal(pointOnRectBoundary({ x: 100, y: 25 }, A, 2), true);
});

test('pointOnRectBoundary: a far point is not on the boundary', () => {
  assert.equal(pointOnRectBoundary({ x: 300, y: 25 }, A, 2), false);
});

test('pointOnRectBoundary: a point just outside within tolerance counts', () => {
  assert.equal(pointOnRectBoundary({ x: 101.5, y: 25 }, A, 2), true);
});

test('segmentsIntersect: crossing segments intersect', () => {
  assert.equal(
    segmentsIntersect({ x: 0, y: 0 }, { x: 10, y: 10 }, { x: 0, y: 10 }, { x: 10, y: 0 }),
    true,
  );
});

test('segmentsIntersect: parallel segments do not intersect', () => {
  assert.equal(
    segmentsIntersect({ x: 0, y: 0 }, { x: 10, y: 0 }, { x: 0, y: 5 }, { x: 10, y: 5 }),
    false,
  );
});

test('segmentIntersectsRect: a segment passing through a rect intersects it', () => {
  assert.equal(segmentIntersectsRect({ x: -10, y: 25 }, { x: 110, y: 25 }, A), true);
});

test('segmentIntersectsRect: a segment clear of a rect does not intersect', () => {
  assert.equal(segmentIntersectsRect({ x: -10, y: 200 }, { x: 110, y: 200 }, A), false);
});

test('rectGap: overlapping rects have zero gap', () => {
  assert.equal(rectGap(A, { x: 50, y: 0, w: 100, h: 50 }), 0);
});

test('rectGap: horizontal gap is the clear distance', () => {
  assert.equal(rectGap(A, { x: 130, y: 0, w: 10, h: 50 }), 30);
});
