import { test } from 'node:test';
import assert from 'node:assert/strict';
import {
  parseStoryDag,
  detectCycle,
  danglingRefs,
  readySet,
  parseParkedStories,
} from '../../scripts/dag/story-dag.mjs';

const PRD = `---
project_mode: MVP
story_dag:
  story_002: [story_001]
  story_005: [story_001]
  story_006: [story_002]
---
# PRD
body here
`;

test('parseStoryDag reads the story_dag frontmatter block', () => {
  const dag = parseStoryDag(PRD);
  assert.deepEqual(dag, {
    story_002: ['story_001'],
    story_005: ['story_001'],
    story_006: ['story_002'],
  });
});

test('parseStoryDag returns empty when no block is present', () => {
  assert.deepEqual(parseStoryDag('---\nproject_mode: POC\n---\n# x'), {});
});

test('parseParkedStories reads the parked list', () => {
  assert.deepEqual(
    parseParkedStories('---\nproject_mode: MVP\nparked_stories: [story_003, story_009]\n---\n# x'),
    ['story_003', 'story_009'],
  );
});

test('parseParkedStories is empty when absent', () => {
  assert.deepEqual(parseParkedStories('---\nproject_mode: POC\n---\n# x'), []);
});

test('detectCycle finds a cycle', () => {
  assert.ok(detectCycle({ a: ['b'], b: ['a'] }));
});

test('detectCycle passes an acyclic graph', () => {
  assert.equal(detectCycle({ story_002: ['story_001'], story_006: ['story_002'] }), false);
});

test('danglingRefs flags deps and keys not in the known story set', () => {
  const known = new Set(['story_001', 'story_002']);
  const dangling = danglingRefs({ story_002: ['story_001'], story_009: ['ghost'] }, known);
  // story_009 (unknown key) and ghost (unknown dep) are dangling; story_001 is fine
  assert.deepEqual(dangling.sort(), ['ghost', 'story_009']);
});

test('readySet returns unblocked, incomplete stories', () => {
  const known = ['story_001', 'story_002', 'story_005', 'story_006'];
  const dag = { story_002: ['story_001'], story_005: ['story_001'], story_006: ['story_002'] };
  // only story_001 complete → story_002 and story_005 become ready; story_006 still blocked
  assert.deepEqual(
    readySet(known, dag, new Set(['story_001'])).sort(),
    ['story_002', 'story_005'],
  );
});

test('readySet excludes already-complete stories', () => {
  const known = ['story_001', 'story_002'];
  const dag = { story_002: ['story_001'] };
  assert.deepEqual(readySet(known, dag, new Set(['story_001', 'story_002'])), []);
});

test('readySet: a root story with no deps is ready when incomplete', () => {
  assert.deepEqual(readySet(['story_001'], {}, new Set()), ['story_001']);
});
