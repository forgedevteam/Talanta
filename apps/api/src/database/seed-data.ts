import { sql } from 'drizzle-orm';

import type { Database } from './database.js';
import { talentCategories } from './schema/index.js';

/** Launch categories. `slug` is the stable key; names and order can change freely. */
export const TALENT_CATEGORIES = [
  { slug: 'music', name: 'Music', icon: 'music' },
  { slug: 'dance', name: 'Dance', icon: 'dance' },
  { slug: 'acting', name: 'Acting', icon: 'acting' },
  { slug: 'comedy', name: 'Comedy', icon: 'comedy' },
  { slug: 'art', name: 'Art', icon: 'art' },
  { slug: 'crafts', name: 'Crafts', icon: 'crafts' },
  { slug: 'fashion', name: 'Fashion', icon: 'fashion' },
  { slug: 'spoken-word', name: 'Spoken word', icon: 'spoken-word' },
  { slug: 'film', name: 'Film', icon: 'film' },
  { slug: 'photography', name: 'Photography', icon: 'photography' },
  { slug: 'writing', name: 'Writing', icon: 'writing' },
  { slug: 'food', name: 'Food', icon: 'food' },
] as const;

/** Idempotent: safe to run on every deploy. */
export async function seedTalentCategories(db: Database): Promise<void> {
  await db
    .insert(talentCategories)
    .values(TALENT_CATEGORIES.map((category, index) => ({ ...category, sortOrder: index })))
    .onConflictDoUpdate({
      target: talentCategories.slug,
      set: {
        name: sql`excluded.name`,
        icon: sql`excluded.icon`,
        sortOrder: sql`excluded.sort_order`,
        updatedAt: sql`now()`,
      },
    });
}
