import { createHash, randomBytes, timingSafeEqual } from 'node:crypto';

import { HttpStatus, Inject, Injectable, Logger } from '@nestjs/common';
import { and, eq, isNull } from 'drizzle-orm';

import { CLOCK, type Clock } from '../../../common/clock/clock.js';
import { AppError } from '../../../common/errors/app-error.js';
import { UUID_PATTERN, uuidv7 } from '../../../common/ids/uuidv7.js';
import { APP_CONFIG } from '../../../config/config.module.js';
import type { AppConfig } from '../../../config/env.js';
import { DATABASE, type Database } from '../../../database/database.js';
import { refreshTokens } from '../../../database/schema/index.js';
import { UsersService, type User } from '../../users/users.service.js';
import { TokenService } from '../tokens/token.service.js';

export interface IssuedTokens {
  readonly accessToken: string;
  readonly refreshToken: string;
  readonly accessTokenExpiresIn: number;
}

type Rotation =
  | { readonly kind: 'rejected' }
  | { readonly kind: 'reused'; readonly userId: string; readonly familyId: string }
  | {
      readonly kind: 'rotated';
      readonly userId: string;
      readonly familyId: string;
      readonly refreshToken: string;
    };

const DAY_MS = 86_400_000;
const SECRET_BYTES = 32;

const sha256 = (value: string): string => createHash('sha256').update(value).digest('hex');

/**
 * A refresh token is `<row id>.<secret>`. The id finds the row without a scan;
 * only the hash of the secret is stored, so a database leak yields no usable tokens.
 */
function parseRefreshToken(token: string): { id: string; hash: string } | null {
  const separator = token.indexOf('.');
  if (separator < 0) return null;
  const id = token.slice(0, separator);
  const secret = token.slice(separator + 1);
  if (!UUID_PATTERN.test(id) || secret.length === 0) return null;
  return { id, hash: sha256(secret) };
}

const sameHash = (a: string, b: string): boolean =>
  a.length === b.length && timingSafeEqual(Buffer.from(a), Buffer.from(b));

/**
 * Sign-in sessions built on rotating refresh tokens. Each refresh spends the
 * old token and issues a successor in the same family. Presenting a spent
 * token again means it leaked, so the whole family is revoked.
 */
@Injectable()
export class SessionService {
  private readonly logger = new Logger(SessionService.name);

  constructor(
    @Inject(DATABASE) private readonly db: Database,
    @Inject(APP_CONFIG) private readonly config: AppConfig,
    @Inject(CLOCK) private readonly clock: Clock,
    private readonly tokens: TokenService,
    private readonly users: UsersService,
  ) {}

  async start(user: Pick<User, 'id' | 'role'>, deviceName: string | null): Promise<IssuedTokens> {
    const familyId = uuidv7(this.clock.now().getTime());
    const refreshToken = await this.insertToken(this.db, user.id, familyId, deviceName);
    return this.withAccessToken(user, familyId, refreshToken);
  }

  async rotate(presented: string): Promise<IssuedTokens> {
    const parsed = parseRefreshToken(presented);
    if (!parsed) throw this.expired();

    const now = this.clock.now();
    const leewayMs = this.config.refresh.reuseLeewaySeconds * 1000;

    // The outcome is returned, not thrown, so that a family revocation commits.
    const rotation = await this.db.transaction(async (tx): Promise<Rotation> => {
      const [row] = await tx
        .select()
        .from(refreshTokens)
        .where(eq(refreshTokens.id, parsed.id))
        .limit(1)
        .for('update');
      if (!row || !sameHash(row.tokenHash, parsed.hash)) return { kind: 'rejected' };
      if (row.revokedAt || row.expiresAt.getTime() <= now.getTime()) return { kind: 'rejected' };

      if (row.usedAt) {
        // A retry after a dropped response is normal on a weak connection, so a
        // spent token still works for a few seconds. After that it is a replay.
        if (now.getTime() - row.usedAt.getTime() > leewayMs) {
          await tx
            .update(refreshTokens)
            .set({ revokedAt: now })
            .where(and(eq(refreshTokens.familyId, row.familyId), isNull(refreshTokens.revokedAt)));
          return { kind: 'reused', userId: row.userId, familyId: row.familyId };
        }
      } else {
        await tx.update(refreshTokens).set({ usedAt: now }).where(eq(refreshTokens.id, row.id));
      }

      const refreshToken = await this.insertToken(tx, row.userId, row.familyId, row.deviceName);
      return { kind: 'rotated', userId: row.userId, familyId: row.familyId, refreshToken };
    });

    if (rotation.kind === 'rejected') throw this.expired();
    if (rotation.kind === 'reused') {
      this.logger.warn(
        `Refresh token replayed: session ${rotation.familyId} of user ${rotation.userId} revoked`,
      );
      throw this.expired();
    }

    const user = await this.users.findById(rotation.userId);
    if (user?.status !== 'active') {
      await this.revokeFamily(rotation.familyId);
      throw new AppError(HttpStatus.FORBIDDEN, 'account_suspended', 'This account is not active.');
    }
    return this.withAccessToken(user, rotation.familyId, rotation.refreshToken);
  }

  /** Signs the device out. Unknown or already-dead tokens are ignored. */
  async end(presented: string): Promise<void> {
    const parsed = parseRefreshToken(presented);
    if (!parsed) return;
    const [row] = await this.db
      .select({ familyId: refreshTokens.familyId, tokenHash: refreshTokens.tokenHash })
      .from(refreshTokens)
      .where(eq(refreshTokens.id, parsed.id))
      .limit(1);
    if (!row || !sameHash(row.tokenHash, parsed.hash)) return;
    await this.revokeFamily(row.familyId);
  }

  private async revokeFamily(familyId: string): Promise<void> {
    await this.db
      .update(refreshTokens)
      .set({ revokedAt: this.clock.now() })
      .where(and(eq(refreshTokens.familyId, familyId), isNull(refreshTokens.revokedAt)));
  }

  private async insertToken(
    db: Database,
    userId: string,
    familyId: string,
    deviceName: string | null,
  ): Promise<string> {
    const now = this.clock.now();
    const id = uuidv7(now.getTime());
    const secret = randomBytes(SECRET_BYTES).toString('base64url');
    await db.insert(refreshTokens).values({
      id,
      userId,
      familyId,
      tokenHash: sha256(secret),
      deviceName,
      expiresAt: new Date(now.getTime() + this.config.refresh.ttlDays * DAY_MS),
    });
    return `${id}.${secret}`;
  }

  private async withAccessToken(
    user: Pick<User, 'id' | 'role'>,
    familyId: string,
    refreshToken: string,
  ): Promise<IssuedTokens> {
    const access = await this.tokens.issue({ id: user.id, sessionId: familyId, role: user.role });
    return {
      accessToken: access.token,
      refreshToken,
      accessTokenExpiresIn: access.expiresInSeconds,
    };
  }

  private expired(): AppError {
    return new AppError(
      HttpStatus.UNAUTHORIZED,
      'session_expired',
      'Your session has ended. Sign in again.',
    );
  }
}
