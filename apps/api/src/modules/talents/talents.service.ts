import { HttpStatus, Inject, Injectable } from '@nestjs/common';
import { and, asc, desc, eq, inArray, notInArray, sql } from 'drizzle-orm';

import { AppError } from '../../common/errors/app-error.js';
import { DATABASE, type Database } from '../../database/database.js';
import { talentCategories, userTalents, type TalentCategory } from '../../database/schema/index.js';
import type { TalentLevel } from './dto/talent.dto.js';

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
  constructor(@Inject(DATABASE) private readonly db: Database) {}

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
