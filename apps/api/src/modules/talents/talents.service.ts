import { HttpStatus, Inject, Injectable } from '@nestjs/common';
import { and, asc, desc, eq, inArray, notInArray, sql, type SQL } from 'drizzle-orm';

import { AppError } from '../../common/errors/app-error.js';
import { DATABASE, type Database } from '../../database/database.js';
import { talentCategories, userTalents, type TalentCategory } from '../../database/schema/index.js';
import type { TalentLevel } from './dto/talent.dto.js';

export interface CategorySummary {
  readonly id: string;
  readonly slug: string;
  readonly name: string;
  readonly icon: string;
}

/** Categories change a few times a year; a short cache saves a query per request. */
const CATEGORY_CACHE_MS = 5 * 60_000;

export interface UserTalentView {
  readonly categoryId: string;
  readonly slug: string;
  readonly name: string;
  readonly icon: string;
  readonly level: TalentLevel;
  readonly isPrimary: boolean;
}

@Injectable()
export class TalentsService {
  private cache: { at: number; byId: Map<string, CategorySummary> } | null = null;

  constructor(@Inject(DATABASE) private readonly db: Database) {}

  async categoriesById(): Promise<Map<string, CategorySummary>> {
    const now = Date.now();
    if (this.cache && now - this.cache.at < CATEGORY_CACHE_MS) return this.cache.byId;
    const rows = await this.listCategories();
    const byId = new Map(
      rows.map(({ id, slug, name, icon }) => [id, { id, slug, name, icon }] as const),
    );
    this.cache = { at: now, byId };
    return byId;
  }

  async slugsById(): Promise<Map<string, string>> {
    const byId = await this.categoriesById();
    return new Map([...byId].map(([id, category]) => [id, category.slug]));
  }

  async categoryExists(id: string): Promise<boolean> {
    return (await this.categoriesById()).has(id);
  }

  async findBySlug(slug: string): Promise<CategorySummary | null> {
    for (const category of (await this.categoriesById()).values()) {
      if (category.slug === slug) return category;
    }
    return null;
  }

  /** Each user's main talent, for creator cards. */
  async primaryForUsers(userIds: readonly string[]): Promise<Map<string, CategorySummary>> {
    if (userIds.length === 0) return new Map();
    const rows = await this.db
      .select({ userId: userTalents.userId, categoryId: userTalents.categoryId })
      .from(userTalents)
      .where(and(inArray(userTalents.userId, [...userIds]), eq(userTalents.isPrimary, true)));
    const byId = await this.categoriesById();
    const result = new Map<string, CategorySummary>();
    for (const row of rows) {
      const category = byId.get(row.categoryId);
      if (category) result.set(row.userId, category);
    }
    return result;
  }

  /** Subquery of users who list a category, for other modules to filter by. */
  usersWithCategory(categoryId: string): SQL {
    return sql`(select ${userTalents.userId} from ${userTalents} where ${userTalents.categoryId} = ${categoryId})`;
  }

  async clearForUser(userId: string): Promise<void> {
    await this.db.delete(userTalents).where(eq(userTalents.userId, userId));
  }

  listCategories(): Promise<TalentCategory[]> {
    return this.db.select().from(talentCategories).orderBy(asc(talentCategories.sortOrder));
  }

  /** The user's talents, main talent first. */
  listForUser(userId: string): Promise<UserTalentView[]> {
    return this.db
      .select({
        categoryId: userTalents.categoryId,
        slug: talentCategories.slug,
        name: talentCategories.name,
        icon: talentCategories.icon,
        level: userTalents.level,
        isPrimary: userTalents.isPrimary,
      })
      .from(userTalents)
      .innerJoin(talentCategories, eq(userTalents.categoryId, talentCategories.id))
      .where(eq(userTalents.userId, userId))
      .orderBy(desc(userTalents.isPrimary), asc(talentCategories.sortOrder));
  }

  /**
   * Makes `categoryIds` the user's complete talent list. Talents they keep
   * hold on to their level; `primaryCategoryId` defaults to the first id.
   */
  async replaceForUser(
    userId: string,
    categoryIds: readonly string[],
    primaryCategoryId?: string,
  ): Promise<void> {
    const ids = [...new Set(categoryIds)];
    const primary = primaryCategoryId ?? ids[0];
    if (primary === undefined || !ids.includes(primary)) {
      throw new AppError(
        HttpStatus.UNPROCESSABLE_ENTITY,
        'validation_failed',
        'The main talent must be one of the chosen talents.',
        { fields: { primaryCategoryId: ['Choose your main talent from the ones you picked.'] } },
      );
    }

    const known = await this.db
      .select({ id: talentCategories.id })
      .from(talentCategories)
      .where(inArray(talentCategories.id, ids));
    if (known.length !== ids.length) {
      throw new AppError(
        HttpStatus.UNPROCESSABLE_ENTITY,
        'talent_category_unknown',
        'One of those talents is not on the list.',
      );
    }

    await this.db.transaction(async (tx) => {
      await tx
        .delete(userTalents)
        .where(and(eq(userTalents.userId, userId), notInArray(userTalents.categoryId, ids)));
      // Clear the old main talent first: only one row per user may hold the flag.
      await tx
        .update(userTalents)
        .set({ isPrimary: false })
        .where(and(eq(userTalents.userId, userId), eq(userTalents.isPrimary, true)));
      await tx
        .insert(userTalents)
        .values(
          ids.map((categoryId) => ({ userId, categoryId, isPrimary: categoryId === primary })),
        )
        .onConflictDoUpdate({
          target: [userTalents.userId, userTalents.categoryId],
          set: { isPrimary: sql`excluded.is_primary`, updatedAt: sql`now()` },
        });
    });
  }
}
