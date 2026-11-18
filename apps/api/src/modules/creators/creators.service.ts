import { HttpStatus, Injectable, Logger } from '@nestjs/common';

import { AppError } from '../../common/errors/app-error.js';
import { DEFAULT_PAGE_SIZE, type CursorQueryDto } from '../../common/pagination/cursor.js';
import { RateLimiter } from '../../common/rate-limit/rate-limiter.js';
import { NotificationsService } from '../notifications/notifications.service.js';
import { PortfolioService } from '../portfolio/portfolio.service.js';
import { PeopleService } from '../profiles/people.service.js';
import { ProfilesService } from '../profiles/profiles.service.js';
import { SocialService } from '../social/social.service.js';
import { TalentsService } from '../talents/talents.service.js';
import { UsersService } from '../users/users.service.js';
import type {
  CreatorPageDto,
  CreatorProfileDto,
  CreatorQueryDto,
  FollowingFeedDto,
  FollowStateDto,
} from './dto/creator.dto.js';

const notFound = (): AppError =>
  new AppError(HttpStatus.NOT_FOUND, 'not_found', 'No one goes by that name.');

/** Discovery, public profiles and following. Composes the modules that own the data. */
@Injectable()
export class CreatorsService {
  private readonly logger = new Logger(CreatorsService.name);

  constructor(
    private readonly profiles: ProfilesService,
    private readonly people: PeopleService,
    private readonly talents: TalentsService,
    private readonly portfolio: PortfolioService,
    private readonly social: SocialService,
    private readonly users: UsersService,
    private readonly notifications: NotificationsService,
    private readonly rateLimiter: RateLimiter,
  ) {}

  async search(query: CreatorQueryDto): Promise<CreatorPageDto> {
    const limit = query.limit ?? DEFAULT_PAGE_SIZE;
    const filters = [this.users.activeUserIds()];
    if (query.talent) {
      const category = await this.talents.findBySlug(query.talent);
      if (!category) return { items: [], nextCursor: null };
      filters.push(this.talents.usersWithCategory(category.id));
    }
    const rows = await this.profiles.search({
      query: query.q,
      city: query.city,
      userIdFilters: filters,
      cursor: query.cursor,
      limit,
    });
    const page = rows.slice(0, limit);
    const ids = page.map((row) => row.userId);
    const [people, followers, works] = await Promise.all([
      this.people.summaries(ids),
      this.social.followerCounts(ids),
      this.portfolio.countForUsers(ids),
    ]);
    const items = ids.flatMap((id) => {
      const person = people.get(id);
      return person
        ? [{ ...person, followerCount: followers.get(id) ?? 0, portfolioCount: works.get(id) ?? 0 }]
        : [];
    });
    const last = page.at(-1);
    return { items, nextCursor: rows.length > limit && last ? last.userId : null };
  }

  async profile(username: string, viewerId: string): Promise<CreatorProfileDto> {
    const userId = await this.resolve(username);
    const [people, talents, portfolio, counts, isFollowing, profile] = await Promise.all([
      this.people.summaries([userId]),
      this.talents.listForUser(userId),
      this.portfolio.listForUser(userId),
      this.social.counts(userId),
      this.social.isFollowing(viewerId, userId),
      this.profiles.findByUserId(userId),
    ]);
    const person = people.get(userId);
    if (!person || !profile) throw notFound();
    return {
      ...person,
      bio: profile.bio,
      talents: talents.map((talent) => ({ ...talent })),
      portfolio,
      followerCount: counts.followers,
      followingCount: counts.following,
      isFollowing,
      isMe: userId === viewerId,
    };
  }

  async follow(username: string, viewerId: string): Promise<FollowStateDto> {
    const userId = await this.resolve(username);
    const limit = await this.rateLimiter.consume(`follow:${viewerId}`, {
      limit: 200,
      windowSeconds: 3600,
    });
    if (!limit.allowed) {
      throw new AppError(HttpStatus.TOO_MANY_REQUESTS, 'rate_limited', 'Slow down a little.', {
        retryAfterSeconds: limit.retryAfterSeconds,
      });
    }
    const created = await this.social.follow(viewerId, userId);
    if (created) {
      try {
        await this.notifications.notify({ userId, type: 'new_follower', actorId: viewerId });
      } catch (error) {
        this.logger.error(
          'Notification failed',
          error instanceof Error ? error.stack : String(error),
        );
      }
    }
    return this.followState(viewerId, userId);
  }

  async unfollow(username: string, viewerId: string): Promise<FollowStateDto> {
    const userId = await this.resolve(username);
    await this.social.unfollow(viewerId, userId);
    return this.followState(viewerId, userId);
  }

  async followingFeed(viewerId: string, query: CursorQueryDto): Promise<FollowingFeedDto> {
    const ids = await this.social.followingIds(viewerId);
    const page = await this.portfolio.recentForUsers(
      ids,
      query.cursor,
      query.limit ?? DEFAULT_PAGE_SIZE,
    );
    const people = await this.people.summaries(page.items.map((item) => item.userId));
    return {
      items: page.items.flatMap(({ userId, ...item }) => {
        const creator = people.get(userId);
        return creator ? [{ ...item, creator }] : [];
      }),
      nextCursor: page.nextCursor,
    };
  }

  private async followState(viewerId: string, userId: string): Promise<FollowStateDto> {
    const [isFollowing, counts] = await Promise.all([
      this.social.isFollowing(viewerId, userId),
      this.social.counts(userId),
    ]);
    return { isFollowing, followerCount: counts.followers };
  }

  /** Suspended and deleted accounts are invisible, not "suspended". */
  private async resolve(username: string): Promise<string> {
    const profile = await this.profiles.findByUsername(username);
    if (!profile) throw notFound();
    const user = await this.users.findById(profile.userId);
    if (user?.status !== 'active') throw notFound();
    return profile.userId;
  }
}
