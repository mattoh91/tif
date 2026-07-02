// Pure scheduling logic for the story-level DAG (story_009 spec_002). Decides
// which stories are dispatchable, their live status, and whether the
// plato→aristotle handoff auto-advances (spike) or waits for approval (full).
//
// The actual subagent dispatch is skill-driven (multi-agent-adapter); this
// module is the deterministic, unit-tested brain the driver loop calls.

const toSet = (v) => (v instanceof Set ? v : new Set(v || []));

export function initialDone(graph) {
  return new Set(graph.nodes.filter((n) => n.complete).map((n) => n.story_id));
}

function depsOf(graph, id) {
  return graph.dag?.[id] || [];
}

export function storyStatuses(graph, state) {
  const done = toSet(state.done);
  const running = toSet(state.running);
  const failed = toSet(state.failed);
  return graph.nodes.map((n) => {
    const id = n.story_id;
    let status;
    if (failed.has(id)) status = 'failed';
    else if (done.has(id)) status = 'done';
    else if (running.has(id)) status = 'running';
    else if (depsOf(graph, id).every((d) => done.has(d))) status = 'ready';
    else status = 'blocked';
    return { story_id: id, status };
  });
}

export function dispatchable(graph, state) {
  return storyStatuses(graph, state)
    .filter((s) => s.status === 'ready')
    .map((s) => s.story_id);
}

export function gateFor(graph, storyId) {
  const node = graph.nodes.find((n) => n.story_id === storyId);
  return node && node.weight === 'spike' ? 'auto' : 'approval';
}

export function statusSnapshot(graph, state) {
  return { stories: storyStatuses(graph, state) };
}

// CLI:
//   node scripts/dag/scheduler.mjs status <root>   emit initial dag-status.json
//   node scripts/dag/scheduler.mjs next <root>     list currently dispatchable stories
if (import.meta.url === `file://${process.argv[1]}`) {
  const [, , cmd, root = '.'] = process.argv;
  const { buildGraph } = await import('./story-dag.mjs');
  const graph = buildGraph(root);
  const state = { done: [...initialDone(graph)], running: [], failed: [] };
  if (cmd === 'status') {
    console.log(JSON.stringify(statusSnapshot(graph, state), null, 2));
  } else if (cmd === 'next') {
    console.log(dispatchable(graph, state).join('\n'));
  } else {
    console.error('usage: scheduler.mjs <status|next> <root>');
    process.exit(2);
  }
}
