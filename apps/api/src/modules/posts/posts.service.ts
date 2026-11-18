import { HttpStatus, Inject, Injectable, Logger } from '@nestjs/common';
import { and, asc, count, desc, eq, gt, inArray, lt, sql, type SQL } from 'drizzle-orm';

import { AppError } from '../../common/errors/app-error.js';
import { DEFAULT_PAGE_SIZE, toPage, type CursorQueryDto } from '../../common/pagination/cursor.js';
import { RateLimiter } from '../../common/rate-limit/rate-limiter.js';
import { APP_CONFIG } from '../../config/config.module.js';
import type { AppConfig } from '../../config/env.js';
import { DATABASE, isUniqueViolation, type Database } from '../../database/database.js';
import {
  comments,
  postLikes,
  postMedia,
  posts,
  type Comment,
  type Post,
} from '../../database/schema/index.js';
import { MediaService } from '../media/media.service.js';
import {
  NotificationsService,
  type NewNotification,
} from '../notifications/notifications.service.js';
import { PeopleService } from '../profiles/people.service.js';
import { ProfilesService } from '../profiles/profiles.service.js';
import { SocialService } from '../social/social.service.js';
import { UsersService } from '../users/users.service.js';
import {
  MAX_PHOTOS_PER_POST,
  type CommentDto,
  type CommentPageDto,
  type CreateCommentDto,
  type CreatePostDto,
  type CreatorPostsQueryDto,
  type FeedQueryDto,
  type LikeStateDto,
  type PostDto,
  type PostPageDto,
  type ShareDto,
} from './dto/post.dto.js';

const postNotFound = (): AppError =>
  new AppError(HttpStatus.NOT_FOUND, 'not_found', 'That post is no longer here.');

const invalidPost = (message: string, field = 'mediaIds'): AppError =>
  new AppError(HttpStatus.UNPROCESSABLE_ENTITY, 'validation_failed', message, {
    fields: { [field]: [message] },
  });

/** Posts, likes, comments and shares: the social feed. */
@Injectable()
export class PostsService {
  private readonly logger = new Logger(PostsService.name);

  constructor(
    @Inject(DATABASE) private readonly db: Database,
    @Inject(APP_CONFIG) private readonly config: AppConfig,
    private readonly media: MediaService,
    private readonly people: PeopleService,
    private readonly profiles: ProfilesService,
    private readonly social: SocialService,
    private readonly users: UsersService,
    private readonly notifications: NotificationsService,
    private readonly rateLimiter: RateLimiter,
  ) {}

  // ---- Reading ----

  async feed(viewerId: string, query: FeedQueryDto): Promise<PostPageDto> {
    const filters: SQL[] = [];
    if (query.tab === 'following') {
      // My own posts belong in my Following stream too.
      const ids = [viewerId, ...(await this.social.followingIds(viewerId))];
      filters.push(inArray(posts.authorId, ids));
    }
    return this.page(viewerId, filters, query);
  }

  reels(viewerId: string, query: CursorQueryDto): Promise<PostPageDto> {
    return this.page(viewerId, [eq(posts.isReel, true)], query);
  }

  async byCreator(
    viewerId: string,
    username: string,
    query: CreatorPostsQueryDto,
  ): Promise<PostPageDto> {
    const profile = await this.profiles.findByUsername(username);
    const user = profile ? await this.users.findById(profile.userId) : null;
    if (!profile || user?.status !== 'active') {
      throw new AppError(HttpStatus.NOT_FOUND, 'not_found', 'No one goes by that name.');
    }
    const filters = [eq(posts.authorId, profile.userId)];
    if (query.reels) filters.push(eq(posts.isReel, true));
    return this.page(viewerId, filters, query);
  }

  async get(viewerId: string, postId: string): Promise<PostDto> {
    const row = await this.findVisible(postId);
    const [dto] = await this.toDtos([row], viewerId);
    if (!dto) throw postNotFound();
    return dto;
  }

  async countForAuthor(userId: string): Promise<number> {
    const [row] = await this.db
      .select({ total: count() })
      .from(posts)
      .where(and(eq(posts.authorId, userId), eq(posts.status, 'active')));
    return row?.total ?? 0;
  }

  /** Short previews of posts and comments, for notifications. */
  async snippets(
    postIds: readonly string[],
    commentIds: readonly string[],
  ): Promise<{ posts: Map<string, string>; comments: Map<string, string> }> {
    const cut = (text: string | null): string | null =>
      text === null ? null : text.length > 80 ? `${text.slice(0, 79).trimEnd()}…` : text;
    const [postRows, commentRows] = await Promise.all([
      postIds.length === 0
        ? []
        : this.db
            .select({ id: posts.id, body: posts.body })
            .from(posts)
            .where(and(inArray(posts.id, [...postIds]), eq(posts.status, 'active'))),
      commentIds.length === 0
        ? []
        : this.db
            .select({ id: comments.id, body: comments.body })
            .from(comments)
            .where(and(inArray(comments.id, [...commentIds]), eq(comments.status, 'active'))),
    ]);
    const toMap = (rows: { id: string; body: string | null }[]): Map<string, string> =>
      new Map(
        rows.flatMap((row) => {
          const text = cut(row.body);
          return text ? [[row.id, text] as const] : [];
        }),
      );
    return { posts: toMap(postRows), comments: toMap(commentRows) };
  }

  // ---- Writing ----

  async create(authorId: string, input: CreatePostDto): Promise<PostDto> {
    if (!(await this.profiles.findByUserId(authorId))) {
      throw new AppError(
        HttpStatus.CONFLICT,
        'profile_required',
        'Create your profile before you post.',
      );
    }
    await this.limit(
      `post:${authorId}`,
      30,
      86_400,
      'You have posted a lot today. Come back tomorrow.',
    );

    const body = input.body?.trim() ? input.body.trim() : null;
    const ids = [...new Set(input.mediaIds ?? [])];
    const files = await this.media.findOwned(authorId, ids);
    if (files.length !== ids.length) throw invalidPost('Upload the files first.');
    if (!body && files.length === 0) {
      throw invalidPost('Write something or add a photo or video.', 'body');
    }

    const videos = files.filter((file) => file.kind === 'video');
    if (videos.length > 0 && files.length > 1) {
      throw invalidPost('A post holds one video, or up to ten photos.');
    }
    if (files.length > MAX_PHOTOS_PER_POST) {
      throw invalidPost(`Up to ${MAX_PHOTOS_PER_POST} photos per post.`);
    }
    const kind = videos.length > 0 ? 'video' : files.length > 0 ? 'photo' : 'text';
    if (input.isReel && kind !== 'video') {
      throw invalidPost('Only a video can be a reel.', 'isReel');
    }

    const row = await this.db
      .transaction(async (tx) => {
        const [post] = await tx
          .insert(posts)
          .values({ authorId, kind, body, isReel: input.isReel === true })
          .returning();
        if (!post) throw new Error('Post insert returned no row');
        if (files.length > 0) {
          // The unique index on media_id refuses a file already used by another post.
          await tx
            .insert(postMedia)
            .values(
              files.map((file, position) => ({ postId: post.id, mediaId: file.id, position })),
            );
        }
        return post;
      })
      .catch((error: unknown) => {
        if (isUniqueViolation(error)) throw invalidPost('That file is already in another post.');
        throw error;
      });

    const [dto] = await this.toDtos([row], authorId);
    if (!dto) throw new Error('New post could not be mapped');
    return dto;
  }

  async delete(viewerId: string, postId: string): Promise<void> {
    const removed = await this.db
      .update(posts)
      .set({ status: 'removed' })
      .where(and(eq(posts.id, postId), eq(posts.authorId, viewerId), eq(posts.status, 'active')))
      .returning({ id: posts.id });
    if (removed.length === 0) throw postNotFound();
  }

  /** Moderation: takes a post down whoever wrote it. */
  async removeByModerator(postId: string): Promise<boolean> {
    const removed = await this.db
      .update(posts)
      .set({ status: 'removed' })
      .where(eq(posts.id, postId))
      .returning({ id: posts.id });
    return removed.length > 0;
  }

  async removeAllForAuthor(userId: string): Promise<void> {
    await this.db.update(posts).set({ status: 'removed' }).where(eq(posts.authorId, userId));
    await this.db.update(comments).set({ status: 'removed' }).where(eq(comments.authorId, userId));
  }

  async like(viewerId: string, postId: string): Promise<LikeStateDto> {
    const post = await this.findVisible(postId);
    await this.limit(`like:${viewerId}`, 600, 3600, 'Slow down a little.');
    const created = await this.db.transaction(async (tx) => {
      const inserted = await tx
        .insert(postLikes)
        .values({ postId, userId: viewerId })
        .onConflictDoNothing()
        .returning({ postId: postLikes.postId });
      if (inserted.length === 0) return false;
      await tx
        .update(posts)
        .set({ likesCount: sql`${posts.likesCount} + 1` })
        .where(eq(posts.id, postId));
      return true;
    });
    if (created) {
      await this.notify({
        userId: post.authorId,
        type: 'post_liked',
        actorId: viewerId,
        postId,
        once: true,
      });
    }
    return this.likeState(viewerId, postId);
  }

  async unlike(viewerId: string, postId: string): Promise<LikeStateDto> {
    await this.findVisible(postId);
    await this.db.transaction(async (tx) => {
      const deleted = await tx
        .delete(postLikes)
        .where(and(eq(postLikes.postId, postId), eq(postLikes.userId, viewerId)))
        .returning({ postId: postLikes.postId });
      if (deleted.length === 0) return;
      await tx
        .update(posts)
        .set({ likesCount: sql`greatest(${posts.likesCount} - 1, 0)` })
        .where(eq(posts.id, postId));
    });
    return this.likeState(viewerId, postId);
  }

  async share(viewerId: string, postId: string): Promise<ShareDto> {
    await this.findVisible(postId);
    // Counted, but one person cannot inflate a post's shares.
    const counted = await this.rateLimiter.consume(`share:${viewerId}:${postId}`, {
      limit: 1,
      windowSeconds: 86_400,
    });
    let shareCount: number;
    if (counted.allowed) {
      const [row] = await this.db
        .update(posts)
        .set({ sharesCount: sql`${posts.sharesCount} + 1` })
        .where(eq(posts.id, postId))
        .returning({ sharesCount: posts.sharesCount });
      shareCount = row?.sharesCount ?? 0;
    } else {
      const [row] = await this.db
        .select({ sharesCount: posts.sharesCount })
        .from(posts)
        .where(eq(posts.id, postId));
      shareCount = row?.sharesCount ?? 0;
    }
    return { url: `${this.config.publicWebUrl}/p/${postId}`, shareCount };
  }

  // ---- Comments ----

  async comments(viewerId: string, postId: string, query: CursorQueryDto): Promise<CommentPageDto> {
    const post = await this.findVisible(postId);
    const limit = query.limit ?? DEFAULT_PAGE_SIZE;
    // Oldest first, so a conversation reads top to bottom.
    const rows = await this.db
      .select()
      .from(comments)
      .where(
        and(
          eq(comments.postId, postId),
          eq(comments.status, 'active'),
          sql`${comments.authorId} in ${this.users.activeUserIds()}`,
          query.cursor ? gt(comments.id, query.cursor) : undefined,
        ),
      )
      .orderBy(asc(comments.id))
      .limit(limit + 1);
    const page = toPage(rows, limit);
    return {
      items: await this.commentDtos(page.items, viewerId, post.authorId),
      nextCursor: page.nextCursor,
    };
  }

  async addComment(viewerId: string, postId: string, input: CreateCommentDto): Promise<CommentDto> {
    const post = await this.findVisible(postId);
    if (!(await this.profiles.findByUserId(viewerId))) {
      throw new AppError(
        HttpStatus.CONFLICT,
        'profile_required',
        'Create your profile before you comment.',
      );
    }
    await this.limit(`comment:${viewerId}`, 200, 86_400, 'You have commented a lot today.');
    const row = await this.db.transaction(async (tx) => {
      const [comment] = await tx
        .insert(comments)
        .values({ postId, authorId: viewerId, body: input.body })
        .returning();
      if (!comment) throw new Error('Comment insert returned no row');
      await tx
        .update(posts)
        .set({ commentsCount: sql`${posts.commentsCount} + 1` })
        .where(eq(posts.id, postId));
      return comment;
    });
    await this.notify({
      userId: post.authorId,
      type: 'post_commented',
      actorId: viewerId,
      postId,
      commentId: row.id,
    });
    const [dto] = await this.commentDtos([row], viewerId, post.authorId);
    if (!dto) throw new Error('New comment could not be mapped');
    return dto;
  }

  /** The writer can delete a comment, and so can the owner of the post it is on. */
  async deleteComment(viewerId: string, commentId: string): Promise<void> {
    const [row] = await this.db
      .select({ comment: comments, postAuthorId: posts.authorId })
      .from(comments)
      .innerJoin(posts, eq(posts.id, comments.postId))
      .where(and(eq(comments.id, commentId), eq(comments.status, 'active')))
      .limit(1);
    if (!row || (row.comment.authorId !== viewerId && row.postAuthorId !== viewerId)) {
      throw new AppError(HttpStatus.NOT_FOUND, 'not_found', 'That comment is no longer here.');
    }
    await this.db.transaction(async (tx) => {
      await tx.update(comments).set({ status: 'removed' }).where(eq(comments.id, commentId));
      await tx
        .update(posts)
        .set({ commentsCount: sql`greatest(${posts.commentsCount} - 1, 0)` })
        .where(eq(posts.id, row.comment.postId));
    });
  }

  // ---- Helpers ----

  private async page(
    viewerId: string,
    filters: SQL[],
    query: CursorQueryDto,
  ): Promise<PostPageDto> {
    const limit = query.limit ?? DEFAULT_PAGE_SIZE;
    const rows = await this.db
      .select()
      .from(posts)
      .where(
        and(
          eq(posts.status, 'active'),
          sql`${posts.authorId} in ${this.users.activeUserIds()}`,
          ...filters,
          query.cursor ? lt(posts.id, query.cursor) : undefined,
        ),
      )
      .orderBy(desc(posts.id))
      .limit(limit + 1);
    const page = toPage(rows, limit);
    return { items: await this.toDtos(page.items, viewerId), nextCursor: page.nextCursor };
  }

  /** A post anyone may see: not removed, by an account that is still active. */
  private async findVisible(postId: string): Promise<Post> {
    const [row] = await this.db
      .select()
      .from(posts)
      .where(
        and(
          eq(posts.id, postId),
          eq(posts.status, 'active'),
          sql`${posts.authorId} in ${this.users.activeUserIds()}`,
        ),
      )
      .limit(1);
    if (!row) throw postNotFound();
    return row;
  }

  private async toDtos(rows: Post[], viewerId: string): Promise<PostDto[]> {
    if (rows.length === 0) return [];
    const ids = rows.map((row) => row.id);
    const [attachments, liked, authors] = await Promise.all([
      this.db
        .select()
        .from(postMedia)
        .where(inArray(postMedia.postId, ids))
        .orderBy(asc(postMedia.position)),
      this.db
        .select({ postId: postLikes.postId })
        .from(postLikes)
        .where(and(eq(postLikes.userId, viewerId), inArray(postLikes.postId, ids))),
      this.people.summaries(rows.map((row) => row.authorId)),
    ]);
    const files = await this.media.findByIds(attachments.map((item) => item.mediaId));
    const likedIds = new Set(liked.map((item) => item.postId));

    return rows.flatMap((row) => {
      const author = authors.get(row.authorId);
      if (!author) return [];
      const media = attachments.flatMap((item) => {
        const file = item.postId === row.id ? files.get(item.mediaId) : undefined;
        return file ? [this.media.toDto(file)] : [];
      });
      return [
        {
          id: row.id,
          author,
          kind: row.kind,
          body: row.body,
          media,
          isReel: row.isReel,
          likeCount: row.likesCount,
          commentCount: row.commentsCount,
          shareCount: row.sharesCount,
          likedByMe: likedIds.has(row.id),
          isMine: row.authorId === viewerId,
          createdAt: row.createdAt,
        },
      ];
    });
  }

  private async commentDtos(
    rows: Comment[],
    viewerId: string,
    postAuthorId: string,
  ): Promise<CommentDto[]> {
    const authors = await this.people.summaries(rows.map((row) => row.authorId));
    return rows.flatMap((row) => {
      const author = authors.get(row.authorId);
      return author
        ? [
            {
              id: row.id,
              postId: row.postId,
              author,
              body: row.body,
              canDelete: row.authorId === viewerId || postAuthorId === viewerId,
              createdAt: row.createdAt,
            },
          ]
        : [];
    });
  }

  private async likeState(viewerId: string, postId: string): Promise<LikeStateDto> {
    const [[post], [like]] = await Promise.all([
      this.db.select({ likesCount: posts.likesCount }).from(posts).where(eq(posts.id, postId)),
      this.db
        .select({ postId: postLikes.postId })
        .from(postLikes)
        .where(and(eq(postLikes.postId, postId), eq(postLikes.userId, viewerId)))
        .limit(1),
    ]);
    return { liked: like !== undefined, likeCount: post?.likesCount ?? 0 };
  }

  private async limit(key: string, limit: number, windowSeconds: number, message: string) {
    const result = await this.rateLimiter.consume(key, { limit, windowSeconds });
    if (!result.allowed) {
      throw new AppError(HttpStatus.TOO_MANY_REQUESTS, 'rate_limited', message, {
        retryAfterSeconds: result.retryAfterSeconds,
      });
    }
  }

  /** Notifications never fail the action that caused them. */
  private async notify(input: NewNotification): Promise<void> {
    try {
      await this.notifications.notify(input);
    } catch (error) {
      this.logger.error(
        'Notification failed',
        error instanceof Error ? error.stack : String(error),
      );
    }
  }
}
