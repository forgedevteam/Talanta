import { Inject, Injectable } from '@nestjs/common';
import { eq } from 'drizzle-orm';

import { DATABASE, type Database } from '../../database/database.js';
import { users, type User } from '../../database/schema/index.js';

export type { User };
export type UserRole = User['role'];

export interface FoundOrCreatedUser {
  readonly user: User;
  readonly created: boolean;
}

@Injectable()
export class UsersService {
  constructor(@Inject(DATABASE) private readonly db: Database) {}

  async findById(id: string): Promise<User | null> {
    const [user] = await this.db.select().from(users).where(eq(users.id, id)).limit(1);
    return user ?? null;
  }

  /** `YYYY-MM-DD`. */
  async setDateOfBirth(userId: string, dateOfBirth: string): Promise<void> {
    await this.db.update(users).set({ dateOfBirth }).where(eq(users.id, userId));
  }

  /**
   * Signing in with a new number creates the account. Insert-then-select keeps
   * two simultaneous first sign-ins from creating two users.
   */
  async findOrCreateByPhone(phone: string, country: string): Promise<FoundOrCreatedUser> {
    const [created] = await this.db
      .insert(users)
      .values({ phone, country })
      .onConflictDoNothing({ target: users.phone })
      .returning();
    if (created) return { user: created, created: true };

    const [existing] = await this.db.select().from(users).where(eq(users.phone, phone)).limit(1);
    if (!existing) throw new Error(`No user row for a phone number that just conflicted`);
    return { user: existing, created: false };
  }
}
