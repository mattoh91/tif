// Track drift between ARCHI.md (canonical markdown architecture) and the deck's
// hand-authored diagram. /deck writes a drift ref after generating the diagram;
// /finish calls checkDrift to flag a stale diagram (ADR-002).

import { readFile, writeFile } from 'node:fs/promises';
import { createHash } from 'node:crypto';

export function hashArchi(text) {
  return createHash('sha256').update(text, 'utf8').digest('hex');
}

export async function writeDriftRef(archiPath, refPath) {
  const text = await readFile(archiPath, 'utf8');
  const ref = { archi_path: archiPath, archi_sha256: hashArchi(text) };
  await writeFile(refPath, JSON.stringify(ref, null, 2), 'utf8');
  return ref;
}

export async function checkDrift(archiPath, refPath) {
  let ref;
  try {
    ref = JSON.parse(await readFile(refPath, 'utf8'));
  } catch {
    return { stale: true, reason: 'no drift ref: deck diagram was never generated' };
  }
  const current = hashArchi(await readFile(archiPath, 'utf8'));
  if (current !== ref.archi_sha256) {
    return { stale: true, reason: 'ARCHI.md changed since the deck diagram was generated' };
  }
  return { stale: false, reason: 'deck diagram is in sync with ARCHI.md' };
}

// CLI:
//   node scripts/deck/drift.mjs write <ARCHI.md> <ref.json>
//   node scripts/deck/drift.mjs check <ARCHI.md> <ref.json>   (exit 3 if stale)
if (import.meta.url === `file://${process.argv[1]}`) {
  const [, , cmd, archiPath, refPath] = process.argv;
  const run = async () => {
    if (cmd === 'write') {
      await writeDriftRef(archiPath, refPath);
      console.log(`wrote drift ref ${refPath}`);
    } else if (cmd === 'check') {
      const r = await checkDrift(archiPath, refPath);
      console.log(`${r.stale ? 'STALE' : 'OK'}: ${r.reason}`);
      if (r.stale) process.exit(3);
    } else {
      console.error('usage: drift.mjs <write|check> <ARCHI.md> <ref.json>');
      process.exit(2);
    }
  };
  run().catch((e) => {
    console.error(e.message);
    process.exit(1);
  });
}
