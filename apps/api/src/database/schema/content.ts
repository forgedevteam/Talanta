import {
  boolean,
  index,
  integer,
  pgEnum,
  pgTable,
  primaryKey,
  smallint,
  text,
  uniqueIndex,
  uuid,
  varchar,
} from 'drizzle-orm/pg-core';

import { id, timestamps } from './columns.js';
import { users } from './users.js';

export const mediaKind = pgEnum('media_kind', ['image', 'video']);

/**
 * A file someone uploaded. Images are re-encoded on the way in, so what is
 * stored never carries the original's metadata (GPS position, device).
 */
export const media = pgTable(
  'media',
  {
    id: id(),
    ownerId: uuid('owner_id')
      .notNull()
      .references(() => users.id, { onDelete: 'cascade' }),
    kind: mediaKind('kind').notNull(),
    mimeType: varchar('mime_type', { length: 40 }).notNull(),
    /** Where the storage adapter keeps the file; never shown to clients as-is. */
    storageKey: text('storage_key').notNull().unique(),
    bytes: integer('bytes').notNull(),
    width: integer('width'),
    height: integer('height'),
    ...timestamps,
  },
  (table) => [index('media_owner_idx').on(table.ownerId, table.createdAt)],
);

export const postKind = pgEnum('post_kind', ['text', 'photo', 'video']);
export const contentStatus = pgEnum('content_status', ['active', 'removed']);

/** Something a member shared: words, up to ten photos, or one video. */
export const posts = pgTable(
  'posts',
  {
    id: id(),
    authorId: uuid('author_id')
      .notNull()
      .references(() => users.id, { onDelete: 'cascade' }),
    kind: postKind('kind').notNull(),
    body: varchar('body', { length: 2200 }),
    /** A vertical video that also plays in Reels. */
    isReel: boolean('is_reel').notNull().default(false),
    likesCount: integer('likes_count').notNull().default(0),
    commentsCount: integer('comments_count').notNull().default(0),
    sharesCount: integer('shares_count').notNull().default(0),
    status: contentStatus('status').notNull().default('active'),
    ...timestamps,
  },
  (table) => [
    index('posts_author_idx').on(table.authorId, table.id),
    index('posts_feed_idx').on(table.status, table.id),
    index('posts_reels_idx').on(table.isReel, table.status, table.id),
  ],
);

export const postMedia = pgTable(
  'post_media',
  {
    postId: uuid('post_id')
      .notNull()
      .references(() => posts.id, { onDelete: 'cascade' }),
    mediaId: uuid('media_id')
      .notNull()
      .references(() => media.id, { onDelete: 'cascade' }),
    position: smallint('position').notNull(),
    ...timestamps,
  },
  (table) => [
    primaryKey({ columns: [table.postId, table.position] }),
    // A file belongs to one post, so deleting a post never strands another.
    uniqueIndex('post_media_media_key').on(table.mediaId),
  ],
);

export const postLikes = pgTable(
  'post_likes',
  {
    postId: uuid('post_id')
      .notNull()
      .references(() => posts.id, { onDelete: 'cascade' }),
    userId: uuid('user_id')
      .notNull()
      .references(() => users.id, { onDelete: 'cascade' }),
    ...timestamps,
  },
  (table) => [
    primaryKey({ columns: [table.postId, table.userId] }),
    index('post_likes_user_idx').on(table.userId),
  ],
);

export const comments = pgTable(
  'comments',
  {
    id: id(),
    postId: uuid('post_id')
      .notNull()
      .references(() => posts.id, { onDelete: 'cascade' }),
    authorId: uuid('author_id')
      .notNull()
      .references(() => users.id, { onDelete: 'cascade' }),
    body: varchar('body', { length: 500 }).notNull(),
    status: contentStatus('status').notNull().default('active'),
    ...timestamps,
  },
  (table) => [index('comments_post_idx').on(table.postId, table.status, table.id)],
);

export type Media = typeof media.$inferSelect;
export type Post = typeof posts.$inferSelect;
export type Comment = typeof comments.$inferSelect;
