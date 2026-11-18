import { HttpStatus, Inject, Injectable } from '@nestjs/common';
import { and, count, desc, eq, inArray, lt } from 'drizzle-orm';

import { AppError } from '../../common/errors/app-error.js';
import { toPage, type Page } from '../../common/pagination/cursor.js';
import { DATABASE, type Database } from '../../database/database.js';
import { portfolioItems, type PortfolioItem } from '../../database/schema/index.js';
import { TalentsService } from '../talents/talents.service.js';
import type { CreatePortfolioItemDto, PortfolioItemDto } from './dto/portfolio.dto.js';
import { checkPortfolioLink } from './portfolio-link.js';

export type { PortfolioItem };

const MAX_ITEMS_PER_USER = 30;

@Injectable()
export class PortfolioService {
  constructor(
    @Inject(DATABASE) private readonly db: Database,
    private readonly talents: TalentsService,
  ) {}

  async listForUser(userId: string): Promise<PortfolioItemDto[]> {
    const rows = await this.db
      .select()
      .from(portfolioItems)
      .where(eq(portfolioItems.userId, userId))
      .orderBy(desc(portfolioItems.id));
    return this.toDtos(rows);
  }

  async findOwned(userId: string, itemId: string): Promise<PortfolioItem | null> {
    const [row] = await this.db
      .select()
      .from(portfolioItems)
      .where(and(eq(portfolioItems.id, itemId), eq(portfolioItems.userId, userId)))
      .limit(1);
    return row ?? null;
  }

  async findByIds(ids: readonly string[]): Promise<PortfolioItemDto[]> {
    if (ids.length === 0) return [];
    const rows = await this.db
      .select()
      .from(portfolioItems)
      .where(inArray(portfolioItems.id, [...ids]));
    return this.toDtos(rows);
  }

  /** Newest work from a set of creators, for the Following stream. */
  async recentForUsers(
    userIds: readonly string[],
    cursor: string | undefined,
    limit: number,
  ): Promise<Page<PortfolioItemDto & { userId: string }>> {
    if (userIds.length === 0) return { items: [], nextCursor: null };
    const rows = await this.db
      .select()
      .from(portfolioItems)
      .where(
        and(
          inArray(portfolioItems.userId, [...userIds]),
          cursor ? lt(portfolioItems.id, cursor) : undefined,
        ),
      )
      .orderBy(desc(portfolioItems.id))
      .limit(limit + 1);
    const dtos = await this.toDtos(rows);
    const withOwner = dtos.map((dto, index) => ({ ...dto, userId: rows[index]?.userId ?? '' }));
    return toPage(withOwner, limit);
  }

  async create(userId: string, input: CreatePortfolioItemDto): Promise<PortfolioItemDto> {
    const [existing] = await this.db
      .select({ total: count() })
      .from(portfolioItems)
      .where(eq(portfolioItems.userId, userId));
    if ((existing?.total ?? 0) >= MAX_ITEMS_PER_USER) {
      throw new AppError(
        HttpStatus.CONFLICT,
        'limit_reached',
        `A portfolio holds up to ${MAX_ITEMS_PER_USER} pieces. Remove one to add another.`,
      );
    }
    if (input.categoryId && !(await this.talents.categoryExists(input.categoryId))) {
      throw new AppError(
        HttpStatus.UNPROCESSABLE_ENTITY,
        'talent_category_unknown',
        'That talent is not on the list.',
      );
    }

    const { url, platform } = checkPortfolioLink(input.url);
    const [row] = await this.db
      .insert(portfolioItems)
      .values({
        userId,
        title: input.title,
        description: input.description ?? null,
        url,
        platform,
        categoryId: input.categoryId ?? null,
      })
      .returning();
    if (!row) throw new Error('Portfolio insert returned no row');
    const [dto] = await this.toDtos([row]);
    if (!dto) throw new Error('Portfolio item could not be mapped');
    return dto;
  }

  /** Deletes one of the caller's items. Someone else's id looks the same as a missing one. */
  async delete(userId: string, itemId: string): Promise<void> {
    const deleted = await this.db
      .delete(portfolioItems)
      .where(and(eq(portfolioItems.id, itemId), eq(portfolioItems.userId, userId)))
      .returning({ id: portfolioItems.id });
    if (deleted.length === 0) {
      throw new AppError(HttpStatus.NOT_FOUND, 'not_found', 'That piece is not in your portfolio.');
    }
  }

  async deleteAllForUser(userId: string): Promise<void> {
    await this.db.delete(portfolioItems).where(eq(portfolioItems.userId, userId));
  }

  async countForUsers(userIds: readonly string[]): Promise<Map<string, number>> {
    if (userIds.length === 0) return new Map();
    const rows = await this.db
      .select({ userId: portfolioItems.userId, total: count() })
      .from(portfolioItems)
      .where(inArray(portfolioItems.userId, [...userIds]))
      .groupBy(portfolioItems.userId);
    return new Map(rows.map((row) => [row.userId, row.total]));
  }

  private async toDtos(rows: PortfolioItem[]): Promise<PortfolioItemDto[]> {
    const slugs = await this.talents.slugsById();
    return rows.map((row) => ({
      id: row.id,
      title: row.title,
      description: row.description,
      url: row.url,
      platform: row.platform,
      categorySlug: row.categoryId ? (slugs.get(row.categoryId) ?? null) : null,
      createdAt: row.createdAt,
    }));
  }
}
