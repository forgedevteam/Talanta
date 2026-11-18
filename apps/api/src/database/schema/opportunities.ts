import {
  char,
  date,
  index,
  integer,
  pgEnum,
  pgTable,
  uniqueIndex,
  uuid,
  varchar,
} from 'drizzle-orm/pg-core';

import { id, timestamps, timestamptz } from './columns.js';
import { portfolioItems } from './portfolio.js';
import { talentCategories } from './talents.js';
import { users } from './users.js';

export const compensationType = pgEnum('compensation_type', ['paid', 'unpaid', 'negotiable']);
export const opportunityStatus = pgEnum('opportunity_status', ['open', 'closed', 'removed']);
export const applicationStatus = pgEnum('application_status', [
  'submitted',
  'shortlisted',
  'declined',
  'hired',
]);

/** An Open Call: a brief posted by an organiser, brand or fellow creator. */
export const opportunities = pgTable(
  'opportunities',
  {
    id: id(),
    posterId: uuid('poster_id')
      .notNull()
      .references(() => users.id, { onDelete: 'cascade' }),
    title: varchar('title', { length: 100 }).notNull(),
    description: varchar('description', { length: 2000 }).notNull(),
    categoryId: uuid('category_id')
      .notNull()
      .references(() => talentCategories.id, { onDelete: 'restrict' }),
    city: varchar('city', { length: 80 }).notNull(),
    country: char('country', { length: 2 }).notNull(),
    compensation: compensationType('compensation').notNull(),
    /** Whole units of `currency`. XAF has no minor unit. */
    budgetAmount: integer('budget_amount'),
    currency: char('currency', { length: 3 }).notNull().default('XAF'),
    /** Last day applications are accepted, in the poster's calendar. */
    deadline: date('deadline'),
    status: opportunityStatus('status').notNull().default('open'),
    /** Paid placement: shown in the Featured row until this moment. */
    featuredUntil: timestamptz('featured_until'),
    applicationsCount: integer('applications_count').notNull().default(0),
    ...timestamps,
  },
  (table) => [
    index('opportunities_feed_idx').on(table.status, table.createdAt),
    index('opportunities_poster_idx').on(table.posterId),
    index('opportunities_category_idx').on(table.categoryId),
  ],
);

export const applications = pgTable(
  'applications',
  {
    id: id(),
    opportunityId: uuid('opportunity_id')
      .notNull()
      .references(() => opportunities.id, { onDelete: 'cascade' }),
    applicantId: uuid('applicant_id')
      .notNull()
      .references(() => users.id, { onDelete: 'cascade' }),
    message: varchar('message', { length: 1000 }).notNull(),
    portfolioItemId: uuid('portfolio_item_id').references(() => portfolioItems.id, {
      onDelete: 'set null',
    }),
    status: applicationStatus('status').notNull().default('submitted'),
    ...timestamps,
  },
  (table) => [
    uniqueIndex('applications_one_per_person_key').on(table.opportunityId, table.applicantId),
    index('applications_applicant_idx').on(table.applicantId, table.createdAt),
  ],
);

export type Opportunity = typeof opportunities.$inferSelect;
export type Application = typeof applications.$inferSelect;
