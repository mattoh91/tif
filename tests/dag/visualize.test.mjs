import { test } from 'node:test';
import assert from 'node:assert/strict';
import {
  mermaidFlowchart,
  renderMarkdown,
  terminalBoard,
} from '../../scripts/dag/visualize.mjs';

const graph = {
  nodes: [
    { story_id: 'story_001', weight: 'spike', complete: true },
    { story_id: 'story_002', weight: 'full', complete: false },
    { story_id: 'story_005', weight: 'full', complete: false },
  ],
  dag: { story_002: ['story_001'], story_005: ['story_001'] },
};
const statuses = [
  { story_id: 'story_001', status: 'done' },
  { story_id: 'story_002', status: 'running' },
  { story_id: 'story_005', status: 'ready' },
];

test('mermaid flowchart includes every node and dependency edge', () => {
  const m = mermaidFlowchart(graph, statuses);
  assert.match(m, /flowchart TD/);
  for (const id of ['story_001', 'story_002', 'story_005']) assert.match(m, new RegExp(id));
  // edges point dependency --> dependent
  assert.match(m, /story_001\s*-->\s*story_002/);
  assert.match(m, /story_001\s*-->\s*story_005/);
});

test('mermaid encodes status via classDef + class assignment', () => {
  const m = mermaidFlowchart(graph, statuses);
  assert.match(m, /classDef done/);
  assert.match(m, /classDef running/);
  assert.match(m, /class story_001 done/);
  assert.match(m, /class story_002 running/);
});

test('renderMarkdown wraps the flowchart in a mermaid fence and adds no external refs', () => {
  const md = renderMarkdown(graph, statuses);
  assert.match(md, /```mermaid\n[\s\S]*```/);
  assert.doesNotMatch(md, /https?:\/\//);
});

test('terminal board groups stories by status', () => {
  const board = terminalBoard(graph, statuses);
  assert.match(board, /done[\s\S]*story_001/i);
  assert.match(board, /running[\s\S]*story_002/i);
  assert.match(board, /ready[\s\S]*story_005/i);
});
