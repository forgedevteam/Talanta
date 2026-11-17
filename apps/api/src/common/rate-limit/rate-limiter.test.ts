import { describe, expect, it } from 'vitest';

import type { Clock } from '../clock/clock.js';
import { InMemoryKeyValueStore } from '../kv/in-memory-key-value-store.js';
import { RateLimiter } from './rate-limiter.js';

function setup(): { limiter: RateLimiter; advance: (seconds: number) => void } {
  let nowMs = Date.UTC(2026, 10, 15);
  const clock: Clock = { now: () => new Date(nowMs) };
  return {
    limiter: new RateLimiter(new InMemoryKeyValueStore(clock)),
    advance: (seconds) => {
      nowMs += seconds * 1000;
    },
  };
}

describe('RateLimiter', () => {
  const rule = { limit: 2, windowSeconds: 60 };

  it('allows calls up to the limit, then says how long to wait', async () => {
    const { limiter, advance } = setup();

    expect(await limiter.consume('a', rule)).toEqual({ allowed: true, retryAfterSeconds: 0 });
    expect(await limiter.consume('a', rule)).toEqual({ allowed: true, retryAfterSeconds: 0 });

    advance(20);
    expect(await limiter.consume('a', rule)).toEqual({ allowed: false, retryAfterSeconds: 40 });
  });

  it('starts a fresh window once the old one ends', async () => {
    const { limiter, advance } = setup();
    await limiter.consume('a', rule);
    await limiter.consume('a', rule);

    advance(60);

    expect((await limiter.consume('a', rule)).allowed).toBe(true);
  });

  it('counts each key on its own', async () => {
    const { limiter } = setup();
    await limiter.consume('a', rule);
    await limiter.consume('a', rule);

    expect((await limiter.consume('b', rule)).allowed).toBe(true);
  });
});
