// Assemble a self-contained presentation deck (docs/ppt/deck.html) from a
// content model. Mechanical and deterministic: the agent supplies the model
// (narrative/value/component prose synthesised from .gummy artifacts) and a
// pre-embedded architecture SVG; this module only lays it out.
//
// Used by the /deck command (see commands/deck.md and skills/documentation).

import { readFile, writeFile, mkdir } from 'node:fs/promises';
import { dirname } from 'node:path';

export const REQUIRED_SECTION_IDS = ['overview', 'value', 'architecture', 'components'];

export function escapeHtml(s) {
  return String(s)
    .replace(/&/g, '&amp;')
    .replace(/</g, '&lt;')
    .replace(/>/g, '&gt;')
    .replace(/"/g, '&quot;')
    .replace(/'/g, '&#39;');
}

function renderSection(section) {
  const title = `<h2>${escapeHtml(section.title)}</h2>`;
  // svg is trusted, pre-embedded markup; html is trusted authored fragment.
  const body = section.svg
    ? `<div class="diagram">${section.svg}</div>`
    : (section.html ?? '');
  return `<section id="section-${escapeHtml(section.id)}" class="slide">${title}${body}</section>`;
}

const STYLE = `
:root{--bg:#0f1222;--fg:#e9ecf5;--muted:#9aa3b2;--accent:#7c5cff;--card:#171a2e}
*{box-sizing:border-box}
html,body{margin:0;height:100%}
body{background:var(--bg);color:var(--fg);font:16px/1.6 -apple-system,Segoe UI,Roboto,Helvetica,Arial,sans-serif}
.deck{max-width:1100px;margin:0 auto;padding:48px 32px}
.deck-title{font-size:40px;font-weight:800;letter-spacing:-.02em;margin:0 0 32px}
.slide{background:var(--card);border:1px solid #232745;border-radius:16px;padding:32px;margin:0 0 24px}
.slide h2{margin:0 0 16px;font-size:24px;color:var(--accent)}
.diagram{overflow:auto}
.diagram svg{max-width:100%;height:auto}
`.trim();

export function buildDeckHtml(model) {
  const ids = new Set((model.sections ?? []).map((s) => s.id));
  const missing = REQUIRED_SECTION_IDS.filter((id) => !ids.has(id));
  if (missing.length) {
    throw new Error(`deck model missing required section(s): ${missing.join(', ')}`);
  }
  const sections = model.sections.map(renderSection).join('\n');
  return `<!doctype html>
<html lang="en">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>${escapeHtml(model.title)}</title>
<style>${STYLE}</style>
</head>
<body>
<main class="deck">
<h1 class="deck-title">${escapeHtml(model.title)}</h1>
${sections}
</main>
</body>
</html>
`;
}

export async function buildDeckFromModelFile(modelPath, outPath) {
  const model = JSON.parse(await readFile(modelPath, 'utf8'));
  const html = buildDeckHtml(model);
  await mkdir(dirname(outPath), { recursive: true });
  await writeFile(outPath, html, 'utf8');
  return outPath;
}

// CLI: node scripts/deck/build-deck.mjs <model.json> <out.html>
if (import.meta.url === `file://${process.argv[1]}`) {
  const [, , modelPath, outPath = 'docs/ppt/deck.html'] = process.argv;
  if (!modelPath) {
    console.error('usage: build-deck.mjs <model.json> [out.html]');
    process.exit(2);
  }
  buildDeckFromModelFile(modelPath, outPath)
    .then((p) => console.log(`wrote ${p}`))
    .catch((e) => {
      console.error(e.message);
      process.exit(1);
    });
}
