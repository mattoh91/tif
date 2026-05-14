export const DIRECTIONS = Object.freeze({
  up: { x: 0, y: -1 },
  down: { x: 0, y: 1 },
  left: { x: -1, y: 0 },
  right: { x: 1, y: 0 }
});

const DEFAULT_SIZE = 20;

export function createGame(options = {}) {
  const width = options.width ?? DEFAULT_SIZE;
  const height = options.height ?? DEFAULT_SIZE;
  const snake = cloneCells(options.snake ?? [
    { x: Math.floor(width / 2), y: Math.floor(height / 2) },
    { x: Math.floor(width / 2) - 1, y: Math.floor(height / 2) },
    { x: Math.floor(width / 2) - 2, y: Math.floor(height / 2) }
  ]);
  const foodQueue = cloneCells(options.foodQueue ?? []);
  const occupied = new Set(snake.map(cellKey));
  const food = options.food ? { ...options.food } : nextFood(width, height, occupied, foodQueue);

  return {
    width,
    height,
    snake,
    direction: options.direction ?? 'right',
    pendingDirection: options.direction ?? 'right',
    food,
    foodQueue,
    score: options.score ?? 0,
    gameOver: false,
    tick: 0
  };
}

export function changeDirection(game, nextDirection) {
  if (!DIRECTIONS[nextDirection]) {
    return cloneGame(game);
  }

  const current = DIRECTIONS[game.direction];
  const next = DIRECTIONS[nextDirection];
  const reversing = current.x + next.x === 0 && current.y + next.y === 0;

  return {
    ...cloneGame(game),
    pendingDirection: reversing ? game.direction : nextDirection
  };
}

export function stepGame(game) {
  if (game.gameOver) {
    return cloneGame(game);
  }

  const direction = game.pendingDirection;
  const vector = DIRECTIONS[direction];
  const head = game.snake[0];
  const nextHead = { x: head.x + vector.x, y: head.y + vector.y };
  const ateFood = sameCell(nextHead, game.food);
  const bodyToCheck = ateFood ? game.snake : game.snake.slice(0, -1);
  const hitWall = nextHead.x < 0 || nextHead.y < 0 || nextHead.x >= game.width || nextHead.y >= game.height;
  const hitSelf = bodyToCheck.some((cell) => sameCell(cell, nextHead));

  if (hitWall || hitSelf) {
    return {
      ...cloneGame(game),
      direction,
      pendingDirection: direction,
      gameOver: true,
      tick: game.tick + 1
    };
  }

  const snake = [nextHead, ...game.snake];
  if (!ateFood) {
    snake.pop();
  }

  const occupied = new Set(snake.map(cellKey));
  const foodQueue = cloneCells(game.foodQueue);
  const food = ateFood ? nextFood(game.width, game.height, occupied, foodQueue) : { ...game.food };

  return {
    ...cloneGame(game),
    snake,
    direction,
    pendingDirection: direction,
    food,
    foodQueue,
    score: ateFood ? game.score + 1 : game.score,
    tick: game.tick + 1
  };
}

export function restartGame(game) {
  return createGame({
    width: game.width,
    height: game.height,
    foodQueue: game.foodQueue
  });
}

function nextFood(width, height, occupied, queue) {
  while (queue.length > 0) {
    const candidate = queue.shift();
    if (isInside(candidate, width, height) && !occupied.has(cellKey(candidate))) {
      return candidate;
    }
  }

  for (let y = 0; y < height; y += 1) {
    for (let x = 0; x < width; x += 1) {
      const candidate = { x, y };
      if (!occupied.has(cellKey(candidate))) {
        return candidate;
      }
    }
  }

  return { x: -1, y: -1 };
}

function isInside(cell, width, height) {
  return cell.x >= 0 && cell.y >= 0 && cell.x < width && cell.y < height;
}

function sameCell(a, b) {
  return a.x === b.x && a.y === b.y;
}

function cellKey(cell) {
  return `${cell.x},${cell.y}`;
}

function cloneCells(cells) {
  return cells.map((cell) => ({ ...cell }));
}

function cloneGame(game) {
  return {
    ...game,
    snake: cloneCells(game.snake),
    food: { ...game.food },
    foodQueue: cloneCells(game.foodQueue)
  };
}
