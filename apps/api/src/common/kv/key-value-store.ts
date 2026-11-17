export const KEY_VALUE_STORE = Symbol('KEY_VALUE_STORE');

/**
 * Short-lived shared state: sign-in codes, cooldowns and rate-limit counters.
 * Redis in every deployed environment; an in-memory adapter for tests and
 * single-process local development.
 */
export interface KeyValueStore {
  get(key: string): Promise<string | null>;
  set(key: string, value: string, ttlSeconds: number): Promise<void>;
  /** Stores the value only if the key is free. Resolves `true` when it was stored. */
  setIfAbsent(key: string, value: string, ttlSeconds: number): Promise<boolean>;
  /** Atomically adds one. The TTL is applied only when the key is created. */
  increment(key: string, ttlSeconds: number): Promise<number>;
  /** Whole seconds until the key expires; `0` when it does not exist. */
  ttl(key: string): Promise<number>;
  delete(...keys: string[]): Promise<void>;
  ping(): Promise<void>;
  close(): Promise<void>;
}
