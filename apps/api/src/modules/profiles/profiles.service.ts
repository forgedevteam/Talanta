import { HttpStatus, Inject, Injectable } from '@nestjs/common';
import { and, eq, ne } from 'drizzle-orm';

import { AppError } from '../../common/errors/app-error.js';
import { DATABASE, isUniqueViolation, type Database } from '../../database/database.js';
import { profiles, type Profile } from '../../database/schema/index.js';
import type { UsernameStatus } from './dto/profile.dto.js';
import { isReservedUsername } from './username.js';

export type { Profile };

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
      // An emptied bio field clears the bio.
      bio: input.bio === undefined || input.bio === '' ? null : input.bio,
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
}
