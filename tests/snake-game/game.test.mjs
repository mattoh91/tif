import assert from 'node:assert/strict';
import test from 'node:test';
import { changeDirection, createGame, restartGame, stepGame } from './game.js';

test('createGame returns the expected state DTO shape', () => {
  const game = createGame({ width: 8, height: 6, food: { x: 1, y: 1 } });

  assert.equal(game.width, 8);
  assert.equal(game.height, 6);
  assert.equal(game.direction, 'right');
  assert.equal(game.pendingDirection, 'right');
  assert.deepEqual(game.food, { x: 1, y: 1 });
  assert.equal(game.score, 0);
  assert.equal(game.gameOver, false);
  assert.equal(game.tick, 0);
  assert.equal(game.snake.length, 3);
});

test('snake moves one cell per step without growing', () => {
  const game = createGame({
    width: 8,
    height: 6,
    snake: [{ x: 3, y: 2 }, { x: 2, y: 2 }, { x: 1, y: 2 }],
    food: { x: 7, y: 5 }
  });

  const next = stepGame(game);

  assert.deepEqual(next.snake, [{ x: 4, y: 2 }, { x: 3, y: 2 }, { x: 2, y: 2 }]);
  assert.equal(next.score, 0);
  assert.equal(next.gameOver, false);
});

test('eating food grows the snake, increases score, and places next food', () => {
  const game = createGame({
    width: 8,
    height: 6,
    snake: [{ x: 3, y: 2 }, { x: 2, y: 2 }, { x: 1, y: 2 }],
    food: { x: 4, y: 2 },
    foodQueue: [{ x: 0, y: 0 }]
  });

  const next = stepGame(game);

  assert.equal(next.snake.length, 4);
  assert.deepEqual(next.snake[0], { x: 4, y: 2 });
  assert.equal(next.score, 1);
  assert.deepEqual(next.food, { x: 0, y: 0 });
});

test('direction changes reject immediate reversal', () => {
  const game = createGame({ direction: 'right' });

  const reversed = changeDirection(game, 'left');
  const turned = changeDirection(game, 'up');

  assert.equal(reversed.pendingDirection, 'right');
  assert.equal(turned.pendingDirection, 'up');
});

test('wall collision ends the game', () => {
  const game = createGame({
    width: 4,
    height: 4,
    snake: [{ x: 3, y: 1 }, { x: 2, y: 1 }, { x: 1, y: 1 }],
    food: { x: 0, y: 0 }
  });

  const next = stepGame(game);

  assert.equal(next.gameOver, true);
});

test('self collision ends the game', () => {
  const game = createGame({
    width: 6,
    height: 6,
    direction: 'up',
    snake: [
      { x: 2, y: 2 },
      { x: 2, y: 1 },
      { x: 1, y: 1 },
      { x: 1, y: 2 },
      { x: 1, y: 3 },
      { x: 2, y: 3 }
    ],
    food: { x: 5, y: 5 }
  });

  const turned = changeDirection(game, 'left');
  const next = stepGame(turned);

  assert.equal(next.gameOver, true);
});

test('restart clears game over and resets score', () => {
  const gameOver = stepGame(createGame({
    width: 4,
    height: 4,
    snake: [{ x: 3, y: 1 }, { x: 2, y: 1 }, { x: 1, y: 1 }],
    food: { x: 0, y: 0 }
  }));

  const restarted = restartGame(gameOver);

  assert.equal(gameOver.gameOver, true);
  assert.equal(restarted.gameOver, false);
  assert.equal(restarted.score, 0);
  assert.equal(restarted.snake.length, 3);
});
