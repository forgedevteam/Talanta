import { Inject, Injectable } from '@nestjs/common';
import { and, count, desc, eq, isNull, lt } from 'drizzle-orm';

import { CLOCK, type Clock } from '../../common/clock/clock.js';
import { toPage, type Page } from '../../common/pagination/cursor.js';
import { DATABASE, type Database } from '../../database/database.js';
import { notifications, type Notification } from '../../database/schema/index.js';

export type { Notification };
export type NotificationType = Notification['type'];

export interface NewNotification {
  readonly userId: string;
  readonly type: NotificationType;
  readonly actorId?: string;
  readonly opportunityId?: string;
  readonly applicationId?: string;
}

/** Stores notification references. Callers never wait on it to succeed. */
@Injectable()
export class NotificationsService {
  constructor(
    @Inject(DATABASE) private readonly db: Database,
    @Inject(CLOCK) private readonly clock: Clock,
  ) {}

  async notify(input: NewNotification): Promise<void> {
    // Nobody needs to hear about their own actions.
    if (input.actorId === input.userId) return;
    await this.db.insert(notifications).values({
      userId: input.userId,
      type: input.type,
      actorId: input.actorId ?? null,
      opportunityId: input.opportunityId ?? null,
      applicationId: input.applicationId ?? null,
    });
  }

  async list(
    userId: string,
    cursor: string | undefined,
    limit: number,
  ): Promise<Page<Notification>> {
    const rows = await this.db
      .select()
      .from(notifications)
      .where(
        and(eq(notifications.userId, userId), cursor ? lt(notifications.id, cursor) : undefined),
      )
      .orderBy(desc(notifications.id))
      .limit(limit + 1);
    return toPage(rows, limit);
  }

  async unreadCount(userId: string): Promise<number> {
    const [row] = await this.db
      .select({ total: count() })
      .from(notifications)
      .where(and(eq(notifications.userId, userId), isNull(notifications.readAt)));
    return row?.total ?? 0;
  }

  async markAllRead(userId: string): Promise<void> {
    await this.db
      .update(notifications)
      .set({ readAt: this.clock.now() })
      .where(and(eq(notifications.userId, userId), isNull(notifications.readAt)));
  }
}
