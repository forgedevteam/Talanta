import { Redis } from 'ioredis';

import type { KeyValueStore } from './key-value-store.js';

export class RedisKeyValueStore implements KeyValueStore {
  private readonly redis: Redis;

  constructor(url: string) {
    this.redis = new Redis(url, { maxRetriesPerRequest: 2, enableReadyCheck: true });
  }

  get(key: string): Promise<string | null> {
    return this.redis.get(key);
  }

  async set(key: string, value: string, ttlSeconds: number): Promise<void> {
    await this.redis.set(key, value, 'EX', ttlSeconds);
  }

  async setIfAbsent(key: string, value: string, ttlSeconds: number): Promise<boolean> {
    const result = await this.redis.set(key, value, 'EX', ttlSeconds, 'NX');
    return result === 'OK';
  }

  async increment(key: string, ttlSeconds: number): Promise<number> {
    const results = await this.redis.multi().incr(key).expire(key, ttlSeconds, 'NX').exec();
    const [error, count] = results?.[0] ?? [new Error('Redis transaction was discarded'), null];
    if (error) throw error;
    return Number(count);
  }

  async ttl(key: string): Promise<number> {
    return Math.max(0, await this.redis.ttl(key));
  }

  async delete(...keys: string[]): Promise<void> {
    if (keys.length > 0) await this.redis.del(...keys);
  }

  async ping(): Promise<void> {
    await this.redis.ping();
  }

  async close(): Promise<void> {
    await this.redis.quit();
  }
}
