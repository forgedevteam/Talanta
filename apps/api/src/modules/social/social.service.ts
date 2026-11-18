import { HttpStatus, Inject, Injectable } from '@nestjs/common';
import { and, count, eq, inArray } from 'drizzle-orm';

import { AppError } from '../../common/errors/app-error.js';
import { DATABASE, type Database } from '../../database/database.js';
import { follows } from '../../database/schema/index.js';

export interface FollowCounts {
  readonly followers: number;
  readonly following: number;
}

/** Who follows whom. */
@Injectable()
export class SocialService {
  constructor(@Inject(DATABASE) private readonly db: Database) {}

  /** Returns true when this created a new follow, false when it already existed. */
  async follow(followerId: string, followeeId: string): Promise<boolean> {
    if (followerId === followeeId) {
      throw new AppError(
        HttpStatus.UNPROCESSABLE_ENTITY,
        'cannot_follow_self',
        'You cannot follow yourself.',
      );
    }
    const inserted = await this.db
      .insert(follows)
      .values({ followerId, followeeId })
      .onConflictDoNothing()
      .returning({ followerId: follows.followerId });
    return inserted.length > 0;
  }

  async unfollow(followerId: string, followeeId: string): Promise<void> {
    await this.db
      .delete(follows)
      .where(and(eq(follows.followerId, followerId), eq(follows.followeeId, followeeId)));
  }

  async isFollowing(followerId: string, followeeId: string): Promise<boolean> {
    const [row] = await this.db
      .select({ followerId: follows.followerId })
      .from(follows)
      .where(and(eq(follows.followerId, followerId), eq(follows.followeeId, followeeId)))
      .limit(1);
    return row !== undefined;
  }

  async counts(userId: string): Promise<FollowCounts> {
    const [[followers], [following]] = await Promise.all([
      this.db.select({ total: count() }).from(follows).where(eq(follows.followeeId, userId)),
      this.db.select({ total: count() }).from(follows).where(eq(follows.followerId, userId)),
    ]);
    return { followers: followers?.total ?? 0, following: following?.total ?? 0 };
  }

  async followerCounts(userIds: readonly string[]): Promise<Map<string, number>> {
    if (userIds.length === 0) return new Map();
    const rows = await this.db
      .select({ userId: follows.followeeId, total: count() })
      .from(follows)
      .where(inArray(follows.followeeId, [...userIds]))
      .groupBy(follows.followeeId);
    return new Map(rows.map((row) => [row.userId, row.total]));
  }

  async followingIds(userId: string): Promise<string[]> {
    const rows = await this.db
      .select({ id: follows.followeeId })
      .from(follows)
      .where(eq(follows.followerId, userId));
    return rows.map((row) => row.id);
  }

  async removeAllForUser(userId: string): Promise<void> {
    await this.db.delete(follows).where(eq(follows.followerId, userId));
    await this.db.delete(follows).where(eq(follows.followeeId, userId));
  }
}
