import { HttpStatus, Inject, Injectable } from '@nestjs/common';
import { JwtService } from '@nestjs/jwt';

import { CLOCK, type Clock } from '../../../common/clock/clock.js';
import { AppError } from '../../../common/errors/app-error.js';
import { APP_CONFIG } from '../../../config/config.module.js';
import type { AppConfig } from '../../../config/env.js';
import type { AuthUser } from '../auth-user.js';

export const JWT_ISSUER = 'talanta-api';
export const JWT_AUDIENCE = 'talanta-clients';
export const JWT_ALGORITHM = 'HS256';

export interface AccessToken {
  readonly token: string;
  readonly expiresInSeconds: number;
}

const ROLES: readonly string[] = ['member', 'sponsor', 'admin'] satisfies AuthUser['role'][];
const isRole = (value: unknown): value is AuthUser['role'] =>
  typeof value === 'string' && ROLES.includes(value);

/** Short-lived access tokens. Stateless: nothing is looked up to verify one. */
@Injectable()
export class TokenService {
  constructor(
    private readonly jwt: JwtService,
    @Inject(APP_CONFIG) private readonly config: AppConfig,
    @Inject(CLOCK) private readonly clock: Clock,
  ) {}

  async issue(user: AuthUser): Promise<AccessToken> {
    const expiresInSeconds = this.config.jwt.accessTtlSeconds;
    const issuedAt = this.nowSeconds();
    const token = await this.jwt.signAsync({
      sub: user.id,
      sid: user.sessionId,
      role: user.role,
      iat: issuedAt,
      exp: issuedAt + expiresInSeconds,
    });
    return { token, expiresInSeconds };
  }

  async verify(token: string): Promise<AuthUser> {
    try {
      const claims = await this.jwt.verifyAsync<Record<string, unknown>>(token, {
        clockTimestamp: this.nowSeconds(),
      });
      const { sub, sid, role } = claims;
      if (typeof sub === 'string' && typeof sid === 'string' && isRole(role)) {
        return { id: sub, sessionId: sid, role };
      }
    } catch {
      // Expired, malformed, wrong signature: the caller learns the same thing.
    }
    throw new AppError(HttpStatus.UNAUTHORIZED, 'unauthorized', 'Sign in to continue.');
  }

  private nowSeconds(): number {
    return Math.floor(this.clock.now().getTime() / 1000);
  }
}
