import { index, pgEnum, pgTable, text, uuid, varchar } from 'drizzle-orm/pg-core';

import { id, timestamps } from './columns.js';
import { talentCategories } from './talents.js';
import { users } from './users.js';

/** Where a portfolio link points. Derived from the URL host, never trusted from input. */
export const portfolioPlatform = pgEnum('portfolio_platform', [
  'youtube',
  'tiktok',
  'instagram',
  'facebook',
  'audiomack',
  'boomplay',
  'soundcloud',
  'spotify',
  'other',
]);

/**
 * A piece of work a creator links to. Talanta does not host media yet: work
 * lives on the platforms creators already use, and this is the curated index.
 */
export const portfolioItems = pgTable(
  'portfolio_items',
  {
    id: id(),
    userId: uuid('user_id')
      .notNull()
      .references(() => users.id, { onDelete: 'cascade' }),
    title: varchar('title', { length: 80 }).notNull(),
    description: varchar('description', { length: 500 }),
    url: text('url').notNull(),
    platform: portfolioPlatform('platform').notNull(),
    categoryId: uuid('category_id').references(() => talentCategories.id, {
      onDelete: 'set null',
    }),
    ...timestamps,
  },
  (table) => [index('portfolio_items_user_idx').on(table.userId, table.createdAt)],
);

export type PortfolioItem = typeof portfolioItems.$inferSelect;
