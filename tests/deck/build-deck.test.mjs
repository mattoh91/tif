import { test } from 'node:test';
import assert from 'node:assert/strict';
import {
  buildDeckHtml,
  REQUIRED_SECTION_IDS,
} from '../../scripts/deck/build-deck.mjs';

function baseModel(overrides = {}) {
  return {
    title: 'Acme Agent',
    sections: [
      { id: 'overview', title: 'What it does', html: '<p>It answers questions.</p>' },
      { id: 'value', title: 'Measurable value', html: '<p>30% faster triage.</p>' },
      { id: 'architecture', title: 'Architecture', svg: '<svg id="diagram"><rect/></svg>' },
      { id: 'components', title: 'Components & research', html: '<p>Retriever: BM25 (chosen over dense).</p>' },
    ],
    ...overrides,
  };
}

test('renders a section block for every required section id', () => {
  const html = buildDeckHtml(baseModel());
  for (const id of REQUIRED_SECTION_IDS) {
    assert.match(html, new RegExp(`id="section-${id}"`), `missing section ${id}`);
  }
});

test('renders the deck title and each section title', () => {
  const html = buildDeckHtml(baseModel());
  assert.match(html, /Acme Agent/);
  assert.match(html, /What it does/);
  assert.match(html, /Measurable value/);
  assert.match(html, /Components &amp; research/);
});

test('throws when a required section is missing', () => {
  const model = baseModel({
    sections: [
      { id: 'overview', title: 'What it does', html: '<p>x</p>' },
      { id: 'value', title: 'Measurable value', html: '<p>x</p>' },
      { id: 'architecture', title: 'Architecture', svg: '<svg></svg>' },
      // components omitted
    ],
  });
  assert.throws(() => buildDeckHtml(model), /components/);
});

test('inlines the architecture svg rather than linking it', () => {
  const html = buildDeckHtml(baseModel());
  assert.match(html, /<svg id="diagram">/);
});

test('is self-contained: no external http(s) resource references', () => {
  const html = buildDeckHtml(baseModel());
  // No <link href=http...>, <script src=http...>, <img src=http...>, @import url(http...)
  assert.doesNotMatch(html, /(href|src)\s*=\s*["']https?:/i, 'external href/src found');
  assert.doesNotMatch(html, /@import[^;]*https?:/i, 'external @import found');
});

test('escapes the deck title to prevent markup injection', () => {
  const html = buildDeckHtml(baseModel({ title: '<script>alert(1)</script>' }));
  assert.doesNotMatch(html, /<script>alert\(1\)<\/script>/);
  assert.match(html, /&lt;script&gt;/);
});
