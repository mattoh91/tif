# Snake Game Implementation Plan

> For agentic workers: implement under `tests/snake-game/` only. Keep unit TDD internal. Component completion requires `npm test` to pass.

## Goal

Build a dependency-free browser Snake game with automated engine tests.

## Feature 1: Play Snake

**FRD Feature:** F1

**Automated Feature Acceptance Gate:**
- Type: Node scenario test
- Command: `npm test`
- Test data/scenario: deterministic food positions and movement sequence
- Expected result: tests pass for score, growth, collision, restart, and DTO shape

### Component 1.1: Game Engine

**Boundary / Contract:** pure functions exporting game-state DTOs.

**Automated Component Contract Gate:**
- Type: DTO/data-contract and state-transition test
- Command: `npm test`
- Expected result: `tests/game.test.mjs` passes

Status: Complete. `npm test` passes.

Files:

- `game.js`
- `game.test.mjs`
- `package.json`

### Component 1.2: Browser UI

**Boundary / Contract:** `index.html` imports engine functions and renders state to canvas.

**Manual Smoke Gate:**
- Open `index.html` in a browser.
- Use arrow keys or WASD to steer.
- Confirm score increments when food is eaten.
- Confirm restart button resets after game over.

Status: Implemented. Manual browser smoke not run in this pass.
