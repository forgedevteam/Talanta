import { boolean, pgTable, text, uuid, varchar } from 'drizzle-orm/pg-core';

import { timestamps } from './columns.js';
import { users } from './users.js';

export const profiles = pgTable('profiles', {
  userId: uuid('user_id')
    .primaryKey()
    .references(() => users.id, { onDelete: 'cascade' }),
  /** Always stored lower-case. */
  username: varchar('username', { length: 24 }).notNull().unique(),
  displayName: varchar('display_name', { length: 50 }).notNull(),
  bio: varchar('bio', { length: 280 }),
  avatarUrl: text('avatar_url'),
  city: varchar('city', { length: 80 }),
  isVerified: boolean('is_verified').notNull().default(false),
  ...timestamps,
});

export type Profile = typeof profiles.$inferSelect;
