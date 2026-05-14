# Snake Game Caveats

## Assumptions

- The fixture is intentionally scoped to `tests/snake-game/`.
- The automated gate focuses on the engine contract, not pixel-perfect canvas rendering.
- Manual browser smoke testing is acceptable for the thin UI adapter in this dry-run.

## Known Gaps

- No Playwright or browser automation is included because the repo currently avoids extra test dependencies.
- Food placement is deterministic for tests and first-empty-cell fallback for default play, not randomized.
- The canvas UI has not been manually smoked in this session.

## Follow-Ups

- Add a browser automation gate if Sweet later adopts an e2e dependency for fixtures.
- Improve `hooks/update-state` so it detects untracked files as changed files, not only `git diff --name-only HEAD`.
