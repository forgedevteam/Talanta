import { char, index, pgTable, uuid, varchar } from 'drizzle-orm/pg-core';

import { id, timestamps, timestamptz } from './columns.js';
import { users } from './users.js';

/**
 * One row per issued refresh token. Tokens that descend from the same sign-in
 * share a `family_id`, which is what gets revoked on sign-out or on reuse.
 */
export const refreshTokens = pgTable(
  'refresh_tokens',
  {
    id: id(),
    userId: uuid('user_id')
      .notNull()
      .references(() => users.id, { onDelete: 'cascade' }),
    familyId: uuid('family_id').notNull(),
    /** SHA-256 of the secret half of the token, hex encoded. The secret itself is never stored. */
    tokenHash: char('token_hash', { length: 64 }).notNull(),
    deviceName: varchar('device_name', { length: 80 }),
    expiresAt: timestamptz('expires_at').notNull(),
    /** Set when the token was exchanged for its successor. */
    usedAt: timestamptz('used_at'),
    revokedAt: timestamptz('revoked_at'),
    ...timestamps,
  },
  (table) => [
    index('refresh_tokens_family_idx').on(table.familyId),
    index('refresh_tokens_user_idx').on(table.userId),
  ],
);

export type RefreshToken = typeof refreshTokens.$inferSelect;
