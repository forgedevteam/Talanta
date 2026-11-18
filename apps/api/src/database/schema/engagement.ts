import { index, pgEnum, pgTable, text, uniqueIndex, uuid, varchar } from 'drizzle-orm/pg-core';

import { comments, posts } from './content.js';
import { id, timestamps, timestamptz } from './columns.js';
import { applications, opportunities } from './opportunities.js';
import { users } from './users.js';

export const notificationType = pgEnum('notification_type', [
  'application_received',
  'application_status',
  'new_follower',
  'post_liked',
  'post_commented',
]);

/**
 * In-app notifications. Only references are stored; clients turn them into
 * text in the reader's language.
 */
export const notifications = pgTable(
  'notifications',
  {
    id: id(),
    userId: uuid('user_id')
      .notNull()
      .references(() => users.id, { onDelete: 'cascade' }),
    type: notificationType('type').notNull(),
    actorId: uuid('actor_id').references(() => users.id, { onDelete: 'cascade' }),
    opportunityId: uuid('opportunity_id').references(() => opportunities.id, {
      onDelete: 'cascade',
    }),
    applicationId: uuid('application_id').references(() => applications.id, {
      onDelete: 'cascade',
    }),
    postId: uuid('post_id').references(() => posts.id, { onDelete: 'cascade' }),
    commentId: uuid('comment_id').references(() => comments.id, { onDelete: 'cascade' }),
    readAt: timestamptz('read_at'),
    ...timestamps,
  },
  (table) => [index('notifications_user_idx').on(table.userId, table.createdAt)],
);

export const reportTarget = pgEnum('report_target', [
  'user',
  'opportunity',
  'portfolio_item',
  'post',
  'comment',
]);
export const reportReason = pgEnum('report_reason', [
  'scam',
  'harassment',
  'inappropriate',
  'spam',
  'underage',
  'other',
]);
export const reportStatus = pgEnum('report_status', ['open', 'resolved']);

export const reports = pgTable(
  'reports',
  {
    id: id(),
    reporterId: uuid('reporter_id')
      .notNull()
      .references(() => users.id, { onDelete: 'cascade' }),
    targetType: reportTarget('target_type').notNull(),
    targetId: uuid('target_id').notNull(),
    reason: reportReason('reason').notNull(),
    details: varchar('details', { length: 500 }),
    status: reportStatus('status').notNull().default('open'),
    ...timestamps,
  },
  (table) => [
    uniqueIndex('reports_once_per_reporter_key').on(
      table.reporterId,
      table.targetType,
      table.targetId,
    ),
    index('reports_queue_idx').on(table.status, table.createdAt),
  ],
);

export const promotionPlacement = pgEnum('promotion_placement', ['opportunities_feed']);

/** House and sponsor ads, always shown with a Sponsored label. */
export const promotions = pgTable(
  'promotions',
  {
    id: id(),
    sponsorName: varchar('sponsor_name', { length: 60 }).notNull(),
    title: varchar('title', { length: 80 }).notNull(),
    body: varchar('body', { length: 200 }).notNull(),
    ctaLabel: varchar('cta_label', { length: 30 }).notNull(),
    url: text('url').notNull(),
    placement: promotionPlacement('placement').notNull(),
    startsAt: timestamptz('starts_at').notNull(),
    endsAt: timestamptz('ends_at').notNull(),
    ...timestamps,
  },
  (table) => [index('promotions_active_idx').on(table.placement, table.startsAt, table.endsAt)],
);

export type Notification = typeof notifications.$inferSelect;
export type Report = typeof reports.$inferSelect;
export type Promotion = typeof promotions.$inferSelect;
