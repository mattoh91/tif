import { test } from 'node:test';
import assert from 'node:assert/strict';
import {
  storyStatuses,
  dispatchable,
  gateFor,
  statusSnapshot,
  initialDone,
} from '../../scripts/dag/scheduler.mjs';

// Diamond: 001 gates 002 and 005; 002 gates 006.
function graph() {
  return {
    nodes: [
      { story_id: 'story_001', weight: 'spike', complete: false },
      { story_id: 'story_002', weight: 'full', complete: false },
      { story_id: 'story_005', weight: 'full', complete: false },
      { story_id: 'story_006', weight: 'full', complete: false },
    ],
    dag: { story_002: ['story_001'], story_005: ['story_001'], story_006: ['story_002'] },
  };
}

const empty = { done: [], running: [], failed: [] };
const statusOf = (arr, id) => arr.find((s) => s.story_id === id).status;

test('at the start only the dependency-free story is ready', () => {
  const s = storyStatuses(graph(), empty);
  assert.equal(statusOf(s, 'story_001'), 'ready');
  assert.equal(statusOf(s, 'story_002'), 'blocked');
  assert.equal(statusOf(s, 'story_006'), 'blocked');
  assert.deepEqual(dispatchable(graph(), empty), ['story_001']);
});

test('completing the root opens its independent dependents in parallel', () => {
  const state = { done: ['story_001'], running: [], failed: [] };
  assert.deepEqual(dispatchable(graph(), state).sort(), ['story_002', 'story_005']);
  assert.equal(statusOf(storyStatuses(graph(), state), 'story_006'), 'blocked');
});

test('a running story is not re-dispatched', () => {
  const state = { done: ['story_001'], running: ['story_002'], failed: [] };
  assert.deepEqual(dispatchable(graph(), state), ['story_005']);
  assert.equal(statusOf(storyStatuses(graph(), state), 'story_002'), 'running');
});

test('a failed dependency leaves its dependents blocked, never dispatched', () => {
  const state = { done: ['story_001'], running: [], failed: ['story_002'] };
  const s = storyStatuses(graph(), state);
  assert.equal(statusOf(s, 'story_002'), 'failed');
  assert.equal(statusOf(s, 'story_006'), 'blocked');
  assert.ok(!dispatchable(graph(), state).includes('story_006'));
});

test('weight decides the handoff gate', () => {
  assert.equal(gateFor(graph(), 'story_001'), 'auto');     // spike
  assert.equal(gateFor(graph(), 'story_002'), 'approval'); // full
});

test('initialDone seeds completion from the graph', () => {
  const g = graph();
  g.nodes[0].complete = true;
  assert.deepEqual([...initialDone(g)], ['story_001']);
});

test('statusSnapshot matches the tif.story_dag.status shape', () => {
  const snap = statusSnapshot(graph(), empty);
  assert.ok(Array.isArray(snap.stories));
  assert.ok(snap.stories.every((s) => 'story_id' in s && 'status' in s));
});
