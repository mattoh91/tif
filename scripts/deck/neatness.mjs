// Pure neatness-check logic for the deck diagram. Consumes a "scene" of
// measured rendered geometry (rects + edge endpoints, from Playwright) plus
// topology (edge source/target ids, from the embedded draw.io XML) and returns
// a structured report. No browser, no I/O — unit-tested in isolation.
//
// Hard-fail checks block deck acceptance; warn checks are reported only.

import {
  rectsOverlap,
  isOffCanvas,
  pointOnRectBoundary,
  segmentsIntersect,
  segmentIntersectsRect,
  rectGap,
} from './geometry.mjs';

export const DEFAULT_OPTS = { tol: 4, minGap: 16, maxCrossings: 0 };

function nodeById(nodes) {
  return Object.fromEntries(nodes.map((n) => [n.id, n]));
}

export function runNeatnessChecks(scene, opts = {}) {
  const o = { ...DEFAULT_OPTS, ...opts };
  const { viewport, nodes, edges } = scene;
  const byId = nodeById(nodes);
  const checks = [];
  const add = (id, severity, passed, detail) => checks.push({ id, severity, passed, detail });

  // FAIL: overlapping shapes
  {
    const hits = [];
    for (let i = 0; i < nodes.length; i++) {
      for (let j = i + 1; j < nodes.length; j++) {
        if (rectsOverlap(nodes[i].rect, nodes[j].rect)) hits.push(`${nodes[i].id}∩${nodes[j].id}`);
      }
    }
    add('overlapping-shapes', 'fail', hits.length === 0, hits.length ? `overlapping: ${hits.join(', ')}` : 'no shapes overlap');
  }

  // FAIL: off-canvas / clipped
  {
    const off = nodes.filter((n) => isOffCanvas(n.rect, viewport)).map((n) => n.id);
    for (const e of edges) {
      for (const [k, p] of [['tail', e.tail], ['head', e.head]]) {
        if (p && (p.x < 0 || p.y < 0 || p.x > viewport.width || p.y > viewport.height)) {
          off.push(`${e.id}.${k}`);
        }
      }
    }
    add('off-canvas', 'fail', off.length === 0, off.length ? `off-canvas: ${off.join(', ')}` : 'everything within the canvas');
  }

  // FAIL: mislanded / dangling arrows
  {
    const bad = [];
    for (const e of edges) {
      const src = byId[e.source];
      const tgt = byId[e.target];
      if (!src || !tgt) {
        bad.push(`${e.id} dangling (missing ${!src ? e.source : e.target})`);
        continue;
      }
      if (!e.tail || !pointOnRectBoundary(e.tail, src.rect, o.tol)) bad.push(`${e.id} tail off ${e.source}`);
      if (!e.head || !pointOnRectBoundary(e.head, tgt.rect, o.tol)) bad.push(`${e.id} head off ${e.target}`);
    }
    add('mislanded-arrows', 'fail', bad.length === 0, bad.length ? bad.join('; ') : 'all arrows land on their endpoints');
  }

  // WARN: excessive edge crossings
  {
    let crossings = 0;
    for (let i = 0; i < edges.length; i++) {
      for (let j = i + 1; j < edges.length; j++) {
        const a = edges[i];
        const b = edges[j];
        if (a.tail && a.head && b.tail && b.head && segmentsIntersect(a.tail, a.head, b.tail, b.head)) crossings++;
      }
    }
    add('edge-crossings', 'warn', crossings <= o.maxCrossings, `${crossings} crossing(s) (threshold ${o.maxCrossings})`);
  }

  // WARN: edge routed through an unrelated node
  {
    const through = [];
    for (const e of edges) {
      if (!e.tail || !e.head) continue;
      for (const n of nodes) {
        if (n.id === e.source || n.id === e.target) continue;
        if (segmentIntersectsRect(e.tail, e.head, n.rect)) through.push(`${e.id} through ${n.id}`);
      }
    }
    add('edge-through-unrelated-node', 'warn', through.length === 0, through.length ? through.join(', ') : 'no edges cross unrelated nodes');
  }

  // WARN: sub-minimum node spacing
  {
    const tight = [];
    for (let i = 0; i < nodes.length; i++) {
      for (let j = i + 1; j < nodes.length; j++) {
        const gap = rectGap(nodes[i].rect, nodes[j].rect);
        if (gap > 0 && gap < o.minGap) tight.push(`${nodes[i].id}/${nodes[j].id}=${gap.toFixed(0)}px`);
      }
    }
    add('node-spacing', 'warn', tight.length === 0, tight.length ? `tight: ${tight.join(', ')} (min ${o.minGap})` : 'spacing OK');
  }

  // WARN: label overflow (only when label geometry is provided)
  {
    const withLabels = nodes.filter((n) => n.labelRect);
    if (withLabels.length) {
      const over = withLabels
        .filter((n) => {
          const l = n.labelRect;
          const r = n.rect;
          return l.x < r.x || l.y < r.y || l.x + l.w > r.x + r.w || l.y + l.h > r.y + r.h;
        })
        .map((n) => n.id);
      add('label-overflow', 'warn', over.length === 0, over.length ? `label overflow: ${over.join(', ')}` : 'labels fit their shapes');
    }
  }

  const accepted = checks.filter((c) => c.severity === 'fail' && !c.passed).length === 0;
  return { accepted, checks };
}
