import { sql } from 'drizzle-orm';
import { char, date, pgEnum, pgTable, text, uniqueIndex, varchar } from 'drizzle-orm/pg-core';

import { id, timestamps } from './columns.js';

export const userStatus = pgEnum('user_status', ['active', 'suspended', 'deleted']);
export const userRole = pgEnum('user_role', ['member', 'sponsor', 'admin']);

export const users = pgTable(
  'users',
  {
    id: id(),
    /** E.164, for example +2348012345678. Null for accounts created through social sign-in. */
    phone: varchar('phone', { length: 16 }).unique(),
    email: varchar('email', { length: 254 }),
    passwordHash: text('password_hash'),
    status: userStatus('status').notNull().default('active'),
    role: userRole('role').notNull().default('member'),
    dateOfBirth: date('date_of_birth'),
    /** ISO 3166-1 alpha-2. */
    country: char('country', { length: 2 }),
    /** BCP 47 language tag. */
    language: varchar('language', { length: 8 }).notNull().default('en'),
    ...timestamps,
  },
  (table) => [uniqueIndex('users_email_lower_key').on(sql`lower(${table.email})`)],
);

export type User = typeof users.$inferSelect;
