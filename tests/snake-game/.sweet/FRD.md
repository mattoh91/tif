# Snake Game Functional Requirements

## Feature to Component Map

| Feature | Component / Capability | Boundary | Feature Gate | Component Contract Gate | Status |
| --- | --- | --- | --- | --- | --- |
| F1: Play Snake | Game engine | `createGame`, `stepGame`, `changeDirection` state DTOs | `npm test` simulates eating food, scoring, growth, wall collision, and restart | Node contract tests assert DTO shape and transitions | Passing |
| F1: Play Snake | Browser UI | DOM controls and canvas rendering boundary | Manual smoke: open `index.html`, move snake, eat food, restart after collision | Engine tests cover deterministic state; UI calls engine through public API | Implemented; manual smoke not run |

## Requirements

### F1: Play Snake

Functional behavior:

- Render a playable Snake board in the browser.
- Move the snake continuously on a grid.
- Allow arrow keys or WASD to change direction.
- Prevent direct reversal into the snake body.
- Grow the snake and increment score when food is eaten.
- Place food on an empty cell.
- End the game on wall or self collision.
- Allow restart after game over.

Feature acceptance gate:

- `npm test` in `tests/snake-game` passes the simulated gameplay scenarios.

Component contract gates:

- `tests/game.test.mjs` verifies game-state DTO shape and core state transitions.
