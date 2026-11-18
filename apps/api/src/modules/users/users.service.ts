import { Inject, Injectable } from '@nestjs/common';
import { and, eq, inArray, sql, type SQL } from 'drizzle-orm';

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

  async findByIds(ids: readonly string[]): Promise<User[]> {
    if (ids.length === 0) return [];
    return this.db
      .select()
      .from(users)
      .where(inArray(users.id, [...ids]));
  }

  /** Subquery of active account ids, for other modules to filter their own rows by. */
  activeUserIds(): SQL {
    return sql`(select ${users.id} from ${users} where ${users.status} = 'active')`;
  }

  async setStatus(userId: string, status: User['status']): Promise<boolean> {
    const updated = await this.db
      .update(users)
      .set({ status })
      .where(eq(users.id, userId))
      .returning({ id: users.id });
    return updated.length > 0;
  }

  /**
   * Account deletion: the row stays so foreign keys hold, but everything that
   * identifies the person is cleared and the phone number is freed.
   */
  async anonymise(userId: string): Promise<void> {
    await this.db
      .update(users)
      .set({ status: 'deleted', phone: null, email: null, dateOfBirth: null, passwordHash: null })
      .where(and(eq(users.id, userId)));
  }
}
