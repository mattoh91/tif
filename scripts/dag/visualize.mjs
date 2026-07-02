// Thin story-DAG visualizer (story_009 spec_003). Renders the graph + live
// status as a Mermaid flowchart in a self-contained docs/dag.md (renders
// natively on GitHub / VS Code / Obsidian — no runtime to vendor, no network)
// plus a terminal status board. Optional --serve for a localhost live view.

import fs from 'node:fs';
import path from 'node:path';

const STATUS_ORDER = ['running', 'ready', 'blocked', 'failed', 'done'];
const STATUS_STYLE = {
  done: 'fill:#1f6f43,stroke:#2ecc71,color:#fff',
  running: 'fill:#7c5cff,stroke:#a892ff,color:#fff',
  ready: 'fill:#2a4d69,stroke:#4a90d9,color:#fff',
  blocked: 'fill:#3a3a3a,stroke:#777,color:#bbb',
  failed: 'fill:#7a1f1f,stroke:#e74c3c,color:#fff',
};

function statusMap(statuses) {
  return Object.fromEntries(statuses.map((s) => [s.story_id, s.status]));
}

export function mermaidFlowchart(graph, statuses) {
  const st = statusMap(statuses);
  const lines = ['flowchart TD'];
  for (const n of graph.nodes) {
    const badge = n.weight === 'spike' ? ' ◇' : '';
    lines.push(`  ${n.story_id}["${n.story_id}${badge}"]`);
  }
  for (const [story, deps] of Object.entries(graph.dag || {})) {
    for (const dep of deps) lines.push(`  ${dep} --> ${story}`);
  }
  for (const [status, style] of Object.entries(STATUS_STYLE)) {
    lines.push(`  classDef ${status} ${style}`);
  }
  for (const n of graph.nodes) {
    const status = st[n.story_id];
    if (status) lines.push(`  class ${n.story_id} ${status}`);
  }
  return lines.join('\n');
}

export function renderMarkdown(graph, statuses) {
  return `# Story DAG

Legend: ◇ = spike · running / ready / blocked / failed / done.

\`\`\`mermaid
${mermaidFlowchart(graph, statuses)}
\`\`\`
`;
}

export function terminalBoard(graph, statuses) {
  const st = statusMap(statuses);
  const depNote = (id) => {
    const deps = (graph.dag || {})[id] || [];
    return deps.length ? ` (needs ${deps.join(', ')})` : '';
  };
  const lines = ['Story DAG status'];
  for (const status of STATUS_ORDER) {
    const ids = graph.nodes.map((n) => n.story_id).filter((id) => st[id] === status);
    if (ids.length) {
      lines.push(`  ${status}:`);
      for (const id of ids) lines.push(`    - ${id}${status === 'blocked' ? depNote(id) : ''}`);
    }
  }
  return lines.join('\n');
}

// CLI:
//   node scripts/dag/visualize.mjs md <root>       write docs/dag.md
//   node scripts/dag/visualize.mjs board <root>    print the terminal board
//   node scripts/dag/visualize.mjs serve <root>    localhost live view (poll-refresh)
if (import.meta.url === `file://${process.argv[1]}`) {
  const [, , cmd, root = '.'] = process.argv;
  const { buildGraph } = await import('./story-dag.mjs');
  const { statusSnapshot, initialDone } = await import('./scheduler.mjs');
  const graph = buildGraph(root);

  const statuses = (() => {
    const statusFile = path.join(root, 'docs', 'dag-status.json');
    if (fs.existsSync(statusFile)) return JSON.parse(fs.readFileSync(statusFile, 'utf8')).stories;
    return statusSnapshot(graph, { done: [...initialDone(graph)], running: [], failed: [] }).stories;
  })();

  if (cmd === 'md') {
    const out = path.join(root, 'docs', 'dag.md');
    fs.mkdirSync(path.dirname(out), { recursive: true });
    fs.writeFileSync(out, renderMarkdown(graph, statuses), 'utf8');
    console.log(`wrote ${out}`);
  } else if (cmd === 'board') {
    console.log(terminalBoard(graph, statuses));
  } else if (cmd === 'watch') {
    // Live in-terminal board: re-read dag-status.json and redraw on an interval.
    const render = () => {
      const g = buildGraph(root);
      const sf = path.join(root, 'docs', 'dag-status.json');
      const sts = fs.existsSync(sf)
        ? JSON.parse(fs.readFileSync(sf, 'utf8')).stories
        : statusSnapshot(g, { done: [...initialDone(g)], running: [], failed: [] }).stories;
      process.stdout.write('\x1b[2J\x1b[H'); // clear screen + cursor home
      process.stdout.write(`${terminalBoard(g, sts)}\n\n(watching docs/dag-status.json — Ctrl-C to stop)\n`);
    };
    render();
    setInterval(render, Number(process.env.INTERVAL_MS || 2000));
  } else if (cmd === 'serve') {
    const http = await import('node:http');
    const port = Number(process.env.PORT || 8199);
    const server = http.createServer((req, res) => {
      const g = buildGraph(root);
      const sf = path.join(root, 'docs', 'dag-status.json');
      const sts = fs.existsSync(sf)
        ? JSON.parse(fs.readFileSync(sf, 'utf8')).stories
        : statusSnapshot(g, { done: [...initialDone(g)], running: [], failed: [] }).stories;
      res.setHeader('content-type', 'text/plain; charset=utf-8');
      res.setHeader('refresh', '2'); // poll: reload every 2s, no external deps
      res.end(terminalBoard(g, sts) + '\n');
    });
    server.listen(port, () => console.log(`DAG board on http://localhost:${port} (Ctrl-C to stop)`));
  } else {
    console.error('usage: visualize.mjs <md|board|serve> <root>');
    process.exit(2);
  }
}
