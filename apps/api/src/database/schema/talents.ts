import { sql } from 'drizzle-orm';
import {
  boolean,
  index,
  integer,
  pgEnum,
  pgTable,
  primaryKey,
  uniqueIndex,
  uuid,
  varchar,
} from 'drizzle-orm/pg-core';

import { id, timestamps } from './columns.js';
import { users } from './users.js';

export const talentLevel = pgEnum('talent_level', ['emerging', 'skilled', 'professional']);

export const talentCategories = pgTable('talent_categories', {
  id: id(),
  name: varchar('name', { length: 40 }).notNull(),
  slug: varchar('slug', { length: 40 }).notNull().unique(),
  /** Key into the app's icon set, not a URL. */
  icon: varchar('icon', { length: 40 }).notNull(),
  sortOrder: integer('sort_order').notNull().default(0),
  ...timestamps,
});

export const userTalents = pgTable(
  'user_talents',
  {
    userId: uuid('user_id')
      .notNull()
      .references(() => users.id, { onDelete: 'cascade' }),
    categoryId: uuid('category_id')
      .notNull()
      .references(() => talentCategories.id, { onDelete: 'restrict' }),
    level: talentLevel('level').notNull().default('emerging'),
    isPrimary: boolean('is_primary').notNull().default(false),
    ...timestamps,
  },
  (table) => [
    primaryKey({ columns: [table.userId, table.categoryId] }),
    uniqueIndex('user_talents_one_primary_key')
      .on(table.userId)
      .where(sql`${table.isPrimary}`),
    index('user_talents_category_idx').on(table.categoryId),
  ],
);

export type TalentCategory = typeof talentCategories.$inferSelect;
export type UserTalent = typeof userTalents.$inferSelect;
