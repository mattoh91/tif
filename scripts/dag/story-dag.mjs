// Story-level dependency graph for tif (story_009). Reusable model shared by
// the state checker (validation), the scheduler (ready set), and the visualizer.
//
// Story dependencies live in PRD.md frontmatter:
//   story_dag:
//     story_002: [story_001]
//     story_005: [story_001]
//
// Pure functions are unit-tested; buildGraph/validate touch the filesystem.

import fs from 'node:fs';
import path from 'node:path';

export function parseStoryDag(prdText) {
  const fm = prdText.match(/^---\n([\s\S]*?)\n---/);
  if (!fm) return {};
  const lines = fm[1].split(/\r?\n/);
  const start = lines.findIndex((l) => /^story_dag:\s*$/.test(l));
  if (start === -1) return {};
  const dag = {};
  for (let i = start + 1; i < lines.length; i++) {
    const line = lines[i];
    if (!/^\s+\S/.test(line)) break; // dedent → end of block
    const m = line.match(/^\s+(story_\d{3}):\s*\[([^\]]*)\]\s*$/);
    if (m) {
      const deps = m[2].split(',').map((s) => s.trim()).filter(Boolean);
      dag[m[1]] = deps;
    }
  }
  return dag;
}

// Story IDs declared in the PRD stories table (rows like `| story_001 | … |`),
// whether or not a story folder exists yet. Lets story_dag reference the planned
// shape of the project before every folder is scaffolded.
export function parseDeclaredStories(prdText) {
  const ids = new Set();
  for (const line of prdText.split(/\r?\n/)) {
    const m = line.match(/^\|\s*(story_\d{3})\b/);
    if (m) ids.add(m[1]);
  }
  return [...ids];
}

export function parseParkedStories(prdText) {
  const fm = prdText.match(/^---\n([\s\S]*?)\n---/);
  if (!fm) return [];
  const m = fm[1].match(/^parked_stories:\s*\[([^\]]*)\]/m);
  if (!m) return [];
  return m[1].split(',').map((s) => s.trim()).filter(Boolean);
}

export function detectCycle(dag) {
  const WHITE = 0, GRAY = 1, BLACK = 2;
  const color = {};
  const nodes = new Set(Object.keys(dag));
  for (const deps of Object.values(dag)) deps.forEach((d) => nodes.add(d));
  for (const n of nodes) color[n] = WHITE;

  const visit = (n) => {
    color[n] = GRAY;
    for (const dep of dag[n] || []) {
      if (color[dep] === GRAY) return true;
      if (color[dep] === WHITE && visit(dep)) return true;
    }
    color[n] = BLACK;
    return false;
  };
  for (const n of nodes) {
    if (color[n] === WHITE && visit(n)) return true;
  }
  return false;
}

export function danglingRefs(dag, knownIds) {
  const known = knownIds instanceof Set ? knownIds : new Set(knownIds);
  const bad = new Set();
  for (const [story, deps] of Object.entries(dag)) {
    if (!known.has(story)) bad.add(story);
    for (const dep of deps) if (!known.has(dep)) bad.add(dep);
  }
  return [...bad];
}

export function readySet(knownIds, dag, completeSet) {
  const done = completeSet instanceof Set ? completeSet : new Set(completeSet);
  return knownIds.filter((id) => {
    if (done.has(id)) return false;
    return (dag[id] || []).every((dep) => done.has(dep));
  });
}

// --- filesystem-backed helpers (checker / scheduler / visualizer) ---

function storyDirs(plansDir) {
  if (!fs.existsSync(plansDir)) return [];
  return fs.readdirSync(plansDir)
    .filter((n) => /^story_\d{3}_/.test(n))
    .filter((n) => fs.statSync(path.join(plansDir, n)).isDirectory());
}

function specMetas(storyDir) {
  const specsDir = path.join(storyDir, 'specs');
  if (!fs.existsSync(specsDir)) return [];
  return fs.readdirSync(specsDir)
    .filter((n) => /^spec_\d{3}_.*\.md$/.test(n))
    .map((n) => {
      const fm = fs.readFileSync(path.join(specsDir, n), 'utf8').match(/^---\n([\s\S]*?)\n---/);
      const body = fm ? fm[1] : '';
      return {
        completed: /(^|\n)completed:\s*true\b/.test(body),
        spike: /(^|\n)weight:\s*spike\b/.test(body),
      };
    });
}

export function buildGraph(root) {
  const prdPath = path.join(root, '.tif', 'docs', 'PRD.md');
  const prd = fs.existsSync(prdPath) ? fs.readFileSync(prdPath, 'utf8') : '';
  const dag = parseStoryDag(prd);
  const plansDir = path.join(root, '.tif', 'plans');
  const nodes = storyDirs(plansDir).map((dir) => {
    const id = dir.match(/^(story_\d{3})_/)[1];
    const metas = specMetas(path.join(plansDir, dir));
    return {
      story_id: id,
      weight: metas.length && metas.every((m) => m.spike) ? 'spike' : 'full',
      complete: metas.length > 0 && metas.every((m) => m.completed),
    };
  });
  const edges = [];
  for (const [story, deps] of Object.entries(dag)) {
    for (const dep of deps) edges.push({ from: dep, to: story });
  }
  return { nodes, edges, dag };
}

export function validate(root) {
  const { nodes, dag } = buildGraph(root);
  const prdPath = path.join(root, '.tif', 'docs', 'PRD.md');
  const prd = fs.existsSync(prdPath) ? fs.readFileSync(prdPath, 'utf8') : '';
  // Known = scaffolded folders ∪ stories declared in the PRD table. Planned edges
  // to a not-yet-scaffolded but declared story are valid; only truly unknown IDs dangle.
  const known = new Set([...nodes.map((n) => n.story_id), ...parseDeclaredStories(prd)]);
  const issues = [];
  const dangling = danglingRefs(dag, known);
  if (dangling.length) issues.push(`story_dag references unknown stories: ${dangling.sort().join(', ')}`);
  if (detectCycle(dag)) issues.push('story_dag has a dependency cycle');
  return issues;
}

// CLI: node scripts/dag/story-dag.mjs --check <root>  (exit 1 on issues)
if (import.meta.url === `file://${process.argv[1]}`) {
  const [, , flag, root = '.'] = process.argv;
  if (flag === '--check') {
    const issues = validate(root);
    for (const i of issues) console.log(`- [invalid] ${i}`);
    process.exit(issues.length ? 1 : 0);
  } else {
    console.log(JSON.stringify(buildGraph(root), null, 2));
  }
}
