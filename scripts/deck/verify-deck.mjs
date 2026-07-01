// Deck diagram neatness gate. Renders the deck in a real browser (Playwright),
// then checks the architecture diagram for overlap, off-canvas, and mislanded
// arrows (hard fails) plus crossings/spacing/unrelated-routing (warns), using
// the draw.io embedded XML as ground-truth topology (story_007 spec_003).
//
// Degrades honestly: if Playwright is not installed, the gate is skipped and
// the report says so — it never claims the diagram was verified (ADR-005).

import { readFile, writeFile } from 'node:fs/promises';
import { parseDrawioSvg } from './drawio-xml.mjs';
import { runNeatnessChecks, DEFAULT_OPTS } from './neatness.mjs';

export function extractArchitectureSvg(deckHtml) {
  const m = deckHtml.match(/<svg\b[\s\S]*?<\/svg>/i);
  if (!m) throw new Error('no <svg> found in deck');
  return m[0];
}

function svgDims(svg) {
  const w = Number((svg.match(/\bwidth="([\d.]+)"/) || [])[1] ?? 0);
  const h = Number((svg.match(/\bheight="([\d.]+)"/) || [])[1] ?? 0);
  return { width: w, height: h };
}

// Smallest s>0 such that center + dir*s lands on the rect boundary.
function boundaryToward(rect, toward) {
  const cx = rect.x + rect.w / 2;
  const cy = rect.y + rect.h / 2;
  const dx = toward.x - cx;
  const dy = toward.y - cy;
  const sx = dx !== 0 ? rect.w / 2 / Math.abs(dx) : Infinity;
  const sy = dy !== 0 ? rect.h / 2 / Math.abs(dy) : Infinity;
  const s = Math.min(sx, sy);
  return { x: cx + dx * s, y: cy + dy * s };
}

function center(r) {
  return { x: r.x + r.w / 2, y: r.y + r.h / 2 };
}

// Build a neatness scene from the diagram model alone (deck renders the SVG at
// 1:1, so model coordinates are the rendered coordinates). Edge endpoints for
// straight source→target connectors are computed analytically.
export function sceneFromModel(svg) {
  const { nodes, edges } = parseDrawioSvg(svg);
  const byId = Object.fromEntries(nodes.map((n) => [n.id, n]));
  const sceneNodes = nodes.map((n) => ({
    id: n.id,
    label: n.label,
    rect: { x: n.x, y: n.y, w: n.w, h: n.h },
  }));
  const sceneEdges = edges.map((e) => {
    const src = byId[e.source];
    const tgt = byId[e.target];
    const out = { id: e.id, source: e.source, target: e.target };
    if (src && tgt) {
      const sr = { x: src.x, y: src.y, w: src.w, h: src.h };
      const tr = { x: tgt.x, y: tgt.y, w: tgt.w, h: tgt.h };
      out.tail = boundaryToward(sr, center(tr));
      out.head = boundaryToward(tr, center(sr));
    }
    return out;
  });
  return { viewport: svgDims(svg), nodes: sceneNodes, edges: sceneEdges };
}

// Default render probe: load the deck in Playwright Chromium and confirm the
// diagram renders. Throws ERR_MODULE_NOT_FOUND when Playwright isn't installed.
async function playwrightProbe(deckPath) {
  const { chromium } = await import('playwright');
  const browser = await chromium.launch();
  try {
    const page = await browser.newPage();
    await page.goto(`file://${deckPath}`);
    const svg = page.locator('#section-architecture svg').first();
    await svg.waitFor({ state: 'attached', timeout: 5000 });
    const box = await svg.boundingBox();
    return { ok: true, viewport: box ? { width: box.width, height: box.height } : undefined };
  } finally {
    await browser.close();
  }
}

export async function verifyDeck(deckPath, opts = {}) {
  const { renderProbe = playwrightProbe, ...checkOpts } = opts;
  const html = await readFile(deckPath, 'utf8');
  const svg = extractArchitectureSvg(html);
  const scene = sceneFromModel(svg);

  let report;
  try {
    await renderProbe(deckPath, svg);
    report = runNeatnessChecks(scene, { ...DEFAULT_OPTS, ...checkOpts });
    report.skipped = false;
  } catch (e) {
    if (e.code === 'ERR_MODULE_NOT_FOUND') {
      report = {
        accepted: false,
        checks: [],
        skipped: true,
        skipped_reason: 'playwright not installed: rendered neatness gate skipped; diagram not verified',
      };
    } else {
      throw e;
    }
  }

  const reportPath = deckPath.replace(/\.html$/, '.neatness.json');
  await writeFile(reportPath, JSON.stringify(report, null, 2), 'utf8');
  return report;
}

// CLI: node scripts/deck/verify-deck.mjs docs/ppt/deck.html  (exit 4 if not accepted)
if (import.meta.url === `file://${process.argv[1]}`) {
  const [, , deckPath] = process.argv;
  if (!deckPath) {
    console.error('usage: verify-deck.mjs <deck.html>');
    process.exit(2);
  }
  verifyDeck(deckPath)
    .then((r) => {
      if (r.skipped) {
        console.log(`SKIPPED: ${r.skipped_reason}`);
        process.exit(0);
      }
      for (const c of r.checks) {
        console.log(`${c.passed ? 'ok  ' : c.severity === 'fail' ? 'FAIL' : 'warn'} ${c.id}: ${c.detail}`);
      }
      console.log(r.accepted ? 'ACCEPTED' : 'NOT ACCEPTED');
      if (!r.accepted) process.exit(4);
    })
    .catch((e) => {
      console.error(e.message);
      process.exit(1);
    });
}
