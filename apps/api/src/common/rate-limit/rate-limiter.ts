import { Inject, Injectable } from '@nestjs/common';

import { KEY_VALUE_STORE, type KeyValueStore } from '../kv/key-value-store.js';

export interface RateLimitRule {
  /** Maximum number of calls allowed inside one window. */
  readonly limit: number;
  readonly windowSeconds: number;
}

export interface RateLimitResult {
  readonly allowed: boolean;
  /** Seconds until the window resets. `0` when the call was allowed. */
  readonly retryAfterSeconds: number;
}

/**
 * Fixed-window counter on the shared key-value store, so the limit holds
 * across every API instance.
 */
@Injectable()
export class RateLimiter {
  constructor(@Inject(KEY_VALUE_STORE) private readonly store: KeyValueStore) {}

  async consume(key: string, rule: RateLimitRule): Promise<RateLimitResult> {
    const storeKey = `rl:${key}`;
    const count = await this.store.increment(storeKey, rule.windowSeconds);
    if (count <= rule.limit) return { allowed: true, retryAfterSeconds: 0 };
    return { allowed: false, retryAfterSeconds: await this.store.ttl(storeKey) };
  }
}
