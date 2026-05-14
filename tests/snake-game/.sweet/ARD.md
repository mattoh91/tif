# Snake Game Architecture Decisions

## ADR-001: Pure Engine with Browser Adapter

Status: Accepted

Problem:

- The fixture needs a real game while staying cheap to test inside `tests/`.

Options:

- Put all logic in the browser script.
- Use a pure JavaScript engine with an HTML/canvas adapter.

Decision:

- Use a pure engine in `game.js` and a thin browser adapter in `index.html`.

Consequences:

- Node tests can verify state transitions without browser dependencies.
- The browser UI remains simple and manually smoke-testable.
- Visual rendering itself is not covered by automated tests in this fixture.

## ADR-002: No Third-Party Dependencies

Status: Accepted

Problem:

- The Sweet harness should not add runtime dependencies for a small fixture.

Decision:

- Use `node --test` and browser-native ES modules.

Consequences:

- Tests run quickly with the local Node installation.
- No package install step is required.
