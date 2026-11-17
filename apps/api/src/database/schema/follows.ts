import { sql } from 'drizzle-orm';
import { check, index, pgTable, primaryKey, uuid } from 'drizzle-orm/pg-core';

import { timestamps } from './columns.js';
import { users } from './users.js';

export const follows = pgTable(
  'follows',
  {
    followerId: uuid('follower_id')
      .notNull()
      .references(() => users.id, { onDelete: 'cascade' }),
    followeeId: uuid('followee_id')
      .notNull()
      .references(() => users.id, { onDelete: 'cascade' }),
    ...timestamps,
  },
  (table) => [
    primaryKey({ columns: [table.followerId, table.followeeId] }),
    index('follows_followee_idx').on(table.followeeId),
    check('follows_no_self_follow', sql`${table.followerId} <> ${table.followeeId}`),
  ],
);
