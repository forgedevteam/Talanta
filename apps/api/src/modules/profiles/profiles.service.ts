import { HttpStatus, Inject, Injectable } from '@nestjs/common';
import { and, desc, eq, ilike, inArray, lt, ne, or, sql, type SQL } from 'drizzle-orm';

import { AppError } from '../../common/errors/app-error.js';
import { DATABASE, isUniqueViolation, type Database } from '../../database/database.js';
import { profiles, type Profile } from '../../database/schema/index.js';
import type { UsernameStatus } from './dto/profile.dto.js';
import { isReservedUsername } from './username.js';

export type { Profile };

export interface ProfileSearch {
  readonly query?: string;
  readonly city?: string;
  /** Extra conditions on `profiles.user_id`, built by the modules that own the data. */
  readonly userIdFilters: readonly SQL[];
  readonly cursor?: string;
  readonly limit: number;
}

/** Escapes LIKE wildcards so user input matches literally. */
export const likeLiteral = (value: string): string =>
  value.replace(/[\\%_]/g, (char) => '\\' + char);

export interface ProfileInput {
  readonly displayName: string;
  /** Already lower-cased and pattern-checked. */
  readonly username: string;
  readonly city: string;
  readonly bio?: string;
}

@Injectable()
export class ProfilesService {
  constructor(@Inject(DATABASE) private readonly db: Database) {}

  async findByUserId(userId: string): Promise<Profile | null> {
    const [profile] = await this.db
      .select()
      .from(profiles)
      .where(eq(profiles.userId, userId))
      .limit(1);
    return profile ?? null;
  }

  /** A username the asking user already holds counts as available to them. */
  async usernameStatus(username: string, askingUserId: string): Promise<UsernameStatus> {
    if (isReservedUsername(username)) return 'reserved';
    const [holder] = await this.db
      .select({ userId: profiles.userId })
      .from(profiles)
      .where(and(eq(profiles.username, username), ne(profiles.userId, askingUserId)))
      .limit(1);
    return holder ? 'taken' : 'available';
  }

  /** Creates the profile on first save and updates it afterwards. */
  async save(userId: string, input: ProfileInput): Promise<Profile> {
    if (isReservedUsername(input.username)) {
      throw new AppError(HttpStatus.CONFLICT, 'username_reserved', 'That username is reserved.');
    }

    const values = {
      displayName: input.displayName,
      username: input.username,
      city: input.city,
      // Leaving the bio out keeps it; sending it empty clears it.
      ...(input.bio === undefined ? {} : { bio: input.bio === '' ? null : input.bio }),
    };

    try {
      const [saved] = await this.db
        .insert(profiles)
        .values({ userId, ...values })
        .onConflictDoUpdate({ target: profiles.userId, set: { ...values, updatedAt: new Date() } })
        .returning();
      if (!saved) throw new Error('Profile upsert returned no row');
      return saved;
    } catch (error) {
      // The unique index is the source of truth; the availability check is only a hint.
      if (isUniqueViolation(error)) {
        throw new AppError(HttpStatus.CONFLICT, 'username_taken', 'That username is taken.');
      }
      throw error;
    }
  }

  async setAvatar(userId: string, avatarUrl: string | null): Promise<void> {
    await this.db
      .update(profiles)
      .set({ avatarUrl, updatedAt: new Date() })
      .where(eq(profiles.userId, userId));
  }

  async findByUsername(username: string): Promise<Profile | null> {
    const [profile] = await this.db
      .select()
      .from(profiles)
      .where(eq(profiles.username, username.toLowerCase()))
      .limit(1);
    return profile ?? null;
  }

  async findByUserIds(userIds: readonly string[]): Promise<Map<string, Profile>> {
    if (userIds.length === 0) return new Map();
    const rows = await this.db
      .select()
      .from(profiles)
      .where(inArray(profiles.userId, [...userIds]));
    return new Map(rows.map((row) => [row.userId, row]));
  }

  /** Newest creators first, keyset-paginated on the (time-ordered) user id. */
  async search(params: ProfileSearch): Promise<Profile[]> {
    const conditions: (SQL | undefined)[] = params.userIdFilters.map(
      (filter) => sql`${profiles.userId} in ${filter}`,
    );
    const query = params.query?.trim();
    if (query) {
      const pattern = `%${likeLiteral(query.toLowerCase())}%`;
      conditions.push(or(ilike(profiles.username, pattern), ilike(profiles.displayName, pattern)));
    }
    const city = params.city?.trim();
    if (city) conditions.push(ilike(profiles.city, likeLiteral(city)));
    if (params.cursor) conditions.push(lt(profiles.userId, params.cursor));

    return this.db
      .select()
      .from(profiles)
      .where(and(...conditions))
      .orderBy(desc(profiles.userId))
      .limit(params.limit + 1);
  }

  async deleteForUser(userId: string): Promise<void> {
    await this.db.delete(profiles).where(eq(profiles.userId, userId));
  }
}
