import { Global, Inject, Logger, Module, type OnApplicationShutdown } from '@nestjs/common';

import { CLOCK, type Clock } from '../clock/clock.js';
import { APP_CONFIG } from '../../config/config.module.js';
import type { AppConfig } from '../../config/env.js';
import { RateLimiter } from '../rate-limit/rate-limiter.js';
import { InMemoryKeyValueStore } from './in-memory-key-value-store.js';
import { KEY_VALUE_STORE, type KeyValueStore } from './key-value-store.js';
import { RedisKeyValueStore } from './redis-key-value-store.js';

@Global()
@Module({
  providers: [
    {
      provide: KEY_VALUE_STORE,
      inject: [APP_CONFIG, CLOCK],
      useFactory: (config: AppConfig, clock: Clock): KeyValueStore => {
        if (config.redisUrl) return new RedisKeyValueStore(config.redisUrl);
        new Logger('KeyValueModule').warn(
          'REDIS_URL is not set: using the in-memory store. Fine for one local process only.',
        );
        return new InMemoryKeyValueStore(clock);
      },
    },
    RateLimiter,
  ],
  exports: [KEY_VALUE_STORE, RateLimiter],
})
export class KeyValueModule implements OnApplicationShutdown {
  constructor(@Inject(KEY_VALUE_STORE) private readonly store: KeyValueStore) {}

  async onApplicationShutdown(): Promise<void> {
    await this.store.close();
  }
}
