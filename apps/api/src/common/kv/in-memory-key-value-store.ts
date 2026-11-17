import type { Clock } from '../clock/clock.js';
import { systemClock } from '../clock/clock.js';
import type { KeyValueStore } from './key-value-store.js';

interface Entry {
  value: string;
  expiresAtMs: number;
}

/** Per-process store for tests and local development. Never use with more than one API instance. */
export class InMemoryKeyValueStore implements KeyValueStore {
  private readonly entries = new Map<string, Entry>();

  constructor(private readonly clock: Clock = systemClock) {}

  async get(key: string): Promise<string | null> {
    return this.live(key)?.value ?? null;
  }

  async set(key: string, value: string, ttlSeconds: number): Promise<void> {
    this.entries.set(key, { value, expiresAtMs: this.nowMs() + ttlSeconds * 1000 });
  }

  async setIfAbsent(key: string, value: string, ttlSeconds: number): Promise<boolean> {
    if (this.live(key)) return false;
    await this.set(key, value, ttlSeconds);
    return true;
  }

  async increment(key: string, ttlSeconds: number): Promise<number> {
    const entry = this.live(key);
    if (!entry) {
      await this.set(key, '1', ttlSeconds);
      return 1;
    }
    const next = Number(entry.value) + 1;
    entry.value = String(next);
    return next;
  }

  async ttl(key: string): Promise<number> {
    const entry = this.live(key);
    return entry ? Math.max(1, Math.ceil((entry.expiresAtMs - this.nowMs()) / 1000)) : 0;
  }

  async delete(...keys: string[]): Promise<void> {
    for (const key of keys) this.entries.delete(key);
  }

  async ping(): Promise<void> {
    // Always reachable.
  }

  async close(): Promise<void> {
    this.entries.clear();
  }

  private nowMs(): number {
    return this.clock.now().getTime();
  }

  private live(key: string): Entry | undefined {
    const entry = this.entries.get(key);
    if (!entry) return undefined;
    if (entry.expiresAtMs <= this.nowMs()) {
      this.entries.delete(key);
      return undefined;
    }
    return entry;
  }
}
