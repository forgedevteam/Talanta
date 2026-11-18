import {
  HttpStatus,
  Inject,
  Injectable,
  type CanActivate,
  type ExecutionContext,
} from '@nestjs/common';
import type { Request } from 'express';

import { APP_CONFIG } from '../../config/config.module.js';
import type { AppConfig } from '../../config/env.js';
import { AppError } from '../errors/app-error.js';
import { RateLimiter } from './rate-limiter.js';

interface ThrottledRequest extends Request {
  user?: { id: string };
}

/**
 * A ceiling on requests per minute. Signed-in traffic is counted per user,
 * because many people on one mobile network can share an IP address.
 * Anonymous traffic is counted per IP. Runs after the access-token guard.
 */
@Injectable()
export class RequestThrottleGuard implements CanActivate {
  constructor(
    private readonly limiter: RateLimiter,
    @Inject(APP_CONFIG) private readonly config: AppConfig,
  ) {}

  async canActivate(context: ExecutionContext): Promise<boolean> {
    const request = context.switchToHttp().getRequest<ThrottledRequest>();
    const { perUserPerMinute, perIpPerMinute } = this.config.throttle;
    const result = request.user
      ? await this.limiter.consume(`req:user:${request.user.id}`, {
          limit: perUserPerMinute,
          windowSeconds: 60,
        })
      : await this.limiter.consume(`req:ip:${request.ip ?? 'unknown'}`, {
          limit: perIpPerMinute,
          windowSeconds: 60,
        });
    if (!result.allowed) {
      throw new AppError(HttpStatus.TOO_MANY_REQUESTS, 'rate_limited', 'Slow down a little.', {
        retryAfterSeconds: Math.max(1, result.retryAfterSeconds),
      });
    }
    return true;
  }
}
