import { describe, expect, it } from 'vitest';

import { UUID_PATTERN, uuidv7 } from './uuidv7.js';

describe('uuidv7', () => {
  it('produces a version 7, variant 1 UUID', () => {
    const id = uuidv7();

    expect(id).toMatch(UUID_PATTERN);
    expect(id[14]).toBe('7');
    expect('89ab').toContain(id[19]);
  });

  it('encodes the timestamp in the first 48 bits', () => {
    const timestamp = Date.UTC(2026, 10, 15, 9, 0, 0);

    const id = uuidv7(timestamp);

    expect(Number.parseInt(id.replaceAll('-', '').slice(0, 12), 16)).toBe(timestamp);
  });

  it('sorts by creation time', () => {
    const earlier = uuidv7(1_800_000_000_000);
    const later = uuidv7(1_800_000_000_001);

    expect(earlier < later).toBe(true);
  });

  it('does not repeat', () => {
    const ids = new Set(Array.from({ length: 5000 }, () => uuidv7(1_800_000_000_000)));

    expect(ids.size).toBe(5000);
  });
});
