import { eq, inArray } from 'drizzle-orm';
import { drizzle } from 'drizzle-orm/node-postgres';
import pg from 'pg';

import * as schema from './schema/index.js';
import { seedDemoPosts } from './seed-demo-posts.js';
import {
  applications,
  follows,
  notifications,
  opportunities,
  portfolioItems,
  profiles,
  promotions,
  talentCategories,
  userTalents,
  users,
} from './schema/index.js';

// Demo content for local testing and store review: three test accounts that
// sign in with OTP_TEST_CODE, a set of creators, and a week of Open Calls.
// Safe to run more than once. Refuses to run in production.

try {
  process.loadEnvFile();
} catch {
  // No .env file: rely on the real environment.
}

if (process.env.NODE_ENV === 'production') {
  throw new Error('Demo data is for development and staging only.');
}
const url = process.env.DATABASE_URL;
if (!url) throw new Error('DATABASE_URL is not set');

const DAY = 86_400_000;
const search = (platform: 'youtube' | 'audiomack', query: string): string =>
  platform === 'youtube'
    ? `https://www.youtube.com/results?search_query=${encodeURIComponent(query)}`
    : `https://audiomack.com/search?q=${encodeURIComponent(query)}`;

interface Person {
  phone?: string;
  role?: 'member' | 'admin';
  username: string;
  displayName: string;
  city: string;
  bio: string;
  dob: string;
  talents: string[];
  verified?: boolean;
  work: { title: string; platform: 'youtube' | 'audiomack'; query: string; talent: string }[];
}

const TEST_ACCOUNTS: Person[] = [
  {
    phone: '+237699000001',
    username: 'nkeng_sings',
    displayName: 'Nkeng Ebai',
    city: 'Douala',
    bio: 'Chanteuse makossa et afro-soul. Mariages, concerts, studio.',
    dob: '1998-03-14',
    talents: ['music', 'spoken-word'],
    work: [
      {
        title: 'Live acoustique à Bonapriso',
        platform: 'youtube',
        query: 'makossa acoustic live',
        talent: 'music',
      },
      {
        title: 'Afro-soul studio session',
        platform: 'audiomack',
        query: 'afro soul cameroon',
        talent: 'music',
      },
      {
        title: 'Slam: Douala la nuit',
        platform: 'youtube',
        query: 'slam poésie cameroun',
        talent: 'spoken-word',
      },
    ],
  },
  {
    phone: '+237699000002',
    username: 'brice_events',
    displayName: 'Brice Mbarga',
    city: 'Yaoundé',
    bio: 'Event producer and casting for ads and music videos across Cameroon.',
    dob: '1987-09-02',
    talents: ['film'],
    verified: true,
    work: [],
  },
  {
    phone: '+237699000003',
    role: 'admin',
    username: 'talanta_team',
    displayName: 'Talanta Team',
    city: 'Douala',
    bio: 'The team behind Talanta.',
    dob: '1990-01-01',
    talents: ['film'],
    verified: true,
    work: [],
  },
];

const CREATORS: Person[] = [
  {
    username: 'awa_danse',
    displayName: 'Awa Ngono',
    city: 'Yaoundé',
    bio: 'Danseuse bikutsi et afro-contemporain. Clips, scène, ateliers.',
    dob: '2000-07-21',
    talents: ['dance'],
    work: [
      {
        title: 'Chorégraphie bikutsi',
        platform: 'youtube',
        query: 'bikutsi dance choreography',
        talent: 'dance',
      },
      {
        title: 'Afro dance freestyle',
        platform: 'youtube',
        query: 'afro dance cameroon',
        talent: 'dance',
      },
    ],
  },
  {
    username: 'tchoko_comedy',
    displayName: 'Junior Tchoko',
    city: 'Douala',
    bio: 'Stand-up in Pidgin, French and English. Corporate nights welcome.',
    dob: '1994-11-05',
    talents: ['comedy', 'acting'],
    verified: true,
    work: [
      {
        title: 'Stand-up: Taxi for Douala',
        platform: 'youtube',
        query: 'cameroon stand up comedy',
        talent: 'comedy',
      },
    ],
  },
  {
    username: 'fanta_couture',
    displayName: 'Fanta Bello',
    city: 'Garoua',
    bio: 'Couturière. Toghu, kaba et pièces modernes sur mesure.',
    dob: '1992-02-17',
    talents: ['fashion', 'crafts'],
    work: [
      {
        title: 'Collection toghu moderne',
        platform: 'youtube',
        query: 'toghu fashion cameroon',
        talent: 'fashion',
      },
    ],
  },
  {
    username: 'eric_lens',
    displayName: 'Eric Fotso',
    city: 'Bafoussam',
    bio: 'Photographer: portraits, weddings and fashion editorials.',
    dob: '1996-05-30',
    talents: ['photography'],
    work: [
      {
        title: 'Portraits of the West Region',
        platform: 'youtube',
        query: 'portrait photography cameroon',
        talent: 'photography',
      },
    ],
  },
  {
    username: 'manka_acts',
    displayName: 'Manka Fru',
    city: 'Bamenda',
    bio: 'Actress for film and stage. Bilingual. Showreel below.',
    dob: '1999-08-09',
    talents: ['acting'],
    work: [
      {
        title: 'Showreel 2026',
        platform: 'youtube',
        query: 'cameroon film actress showreel',
        talent: 'acting',
      },
    ],
  },
  {
    username: 'dj_kribi',
    displayName: 'DJ Kribi Wave',
    city: 'Kribi',
    bio: 'DJ and producer. Afrobeats, coupé-décalé, makossa remixes.',
    dob: '1997-12-12',
    talents: ['music'],
    work: [
      {
        title: 'Beach set mix',
        platform: 'audiomack',
        query: 'afrobeats mix cameroon',
        talent: 'music',
      },
    ],
  },
];

interface Call {
  title: string;
  description: string;
  talent: string;
  city: string;
  compensation: 'paid' | 'unpaid' | 'negotiable';
  budget?: number;
  daysLeft?: number;
  featuredDays?: number;
}

const CALLS: Call[] = [
  {
    title: 'Chanteuse pour un mariage à Douala',
    description:
      'Nous cherchons une chanteuse pour la réception d’un mariage le samedi 19 décembre à Bonanjo. Deux sets de 45 minutes (makossa, afro-soul, quelques classiques). Sonorisation fournie.',
    talent: 'music',
    city: 'Douala',
    compensation: 'paid',
    budget: 150_000,
    daysLeft: 20,
    featuredDays: 30,
  },
  {
    title: 'Danseurs pour un clip bikutsi',
    description:
      'Tournage d’un clip à Yaoundé sur une journée. Six danseurs et danseuses, chorégraphie fournie, répétition la veille. Repas et transport pris en charge.',
    talent: 'dance',
    city: 'Yaoundé',
    compensation: 'paid',
    budget: 40_000,
    daysLeft: 12,
    featuredDays: 30,
  },
  {
    title: 'Actors for a TV advert (bilingual)',
    description:
      'Casting for a 30-second TV advert for a drinks brand. Two lead roles, ages 22 to 35, comfortable in English and French. Shoot in Douala over two days.',
    talent: 'acting',
    city: 'Douala',
    compensation: 'paid',
    budget: 250_000,
    daysLeft: 15,
  },
  {
    title: 'Comedian for a company year-end party',
    description:
      'Twenty minutes of clean stand-up for 150 guests at a company dinner in Yaoundé on 12 December. French and English mix preferred.',
    talent: 'comedy',
    city: 'Yaoundé',
    compensation: 'paid',
    budget: 100_000,
    daysLeft: 10,
  },
  {
    title: 'Photographe pour défilé de mode',
    description:
      'Défilé de jeunes créateurs à l’Institut Français de Yaoundé. Couverture de la soirée et photos backstage, livraison sous 72 heures.',
    talent: 'photography',
    city: 'Yaoundé',
    compensation: 'negotiable',
    daysLeft: 25,
  },
  {
    title: 'Couturières pour une collection capsule',
    description:
      'Atelier à Douala cherche trois couturières pour une collection de 20 pièces en tissu toghu, sur trois semaines. Paiement à la pièce.',
    talent: 'fashion',
    city: 'Douala',
    compensation: 'paid',
    budget: 15_000,
    daysLeft: 30,
  },
  {
    title: 'Slameurs pour une soirée poésie',
    description:
      'Scène ouverte au café littéraire de Bastos. Cinq slameurs, dix minutes chacun. Bénévole, avec captation vidéo offerte pour vos portfolios.',
    talent: 'spoken-word',
    city: 'Yaoundé',
    compensation: 'unpaid',
    daysLeft: 8,
  },
  {
    title: 'DJ for a beach festival in Kribi',
    description:
      'Two-night beach festival over the New Year weekend. Looking for a DJ for the sunset slot, 5pm to 8pm. Equipment provided, accommodation included.',
    talent: 'music',
    city: 'Kribi',
    compensation: 'negotiable',
    daysLeft: 18,
  },
];

const pool = new pg.Pool({ connectionString: url, max: 2 });
const db = drizzle(pool, { schema });

async function upsertPerson(person: Person, categories: Map<string, string>): Promise<string> {
  const [existing] = await db
    .select({ userId: profiles.userId })
    .from(profiles)
    .where(eq(profiles.username, person.username))
    .limit(1);
  if (existing) return existing.userId;
  if (person.phone) {
    // A test account someone has already edited keeps their changes.
    const [byPhone] = await db
      .select({ userId: profiles.userId })
      .from(profiles)
      .innerJoin(users, eq(users.id, profiles.userId))
      .where(eq(users.phone, person.phone))
      .limit(1);
    if (byPhone) return byPhone.userId;
  }

  const [user] = await db
    .insert(users)
    .values({
      phone: person.phone ?? null,
      role: person.role ?? 'member',
      country: 'CM',
      language: 'fr',
      dateOfBirth: person.dob,
    })
    .onConflictDoNothing({ target: users.phone })
    .returning();
  const userId =
    user?.id ??
    (
      await db
        .select({ id: users.id })
        .from(users)
        .where(eq(users.phone, person.phone ?? ''))
        .limit(1)
    )[0]?.id;
  if (!userId) throw new Error(`Could not create ${person.username}`);

  await db
    .update(users)
    .set({ role: person.role ?? 'member', dateOfBirth: person.dob, status: 'active' })
    .where(eq(users.id, userId));
  await db.insert(profiles).values({
    userId,
    username: person.username,
    displayName: person.displayName,
    city: person.city,
    bio: person.bio,
    isVerified: person.verified ?? false,
  });
  await db.insert(userTalents).values(
    person.talents.map((slug, index) => ({
      userId,
      categoryId: categories.get(slug) ?? '',
      isPrimary: index === 0,
    })),
  );
  for (const work of person.work) {
    await db.insert(portfolioItems).values({
      userId,
      title: work.title,
      url: search(work.platform, work.query),
      platform: work.platform,
      categoryId: categories.get(work.talent) ?? null,
    });
  }
  return userId;
}

try {
  const categories = new Map(
    (await db.select().from(talentCategories)).map((c) => [c.slug, c.id] as const),
  );
  if (categories.size === 0) throw new Error('Run db:migrate first: no talent categories.');

  const ids = new Map<string, string>();
  for (const person of [...TEST_ACCOUNTS, ...CREATORS]) {
    ids.set(person.username, await upsertPerson(person, categories));
  }

  const organiserId = ids.get('brice_events') ?? '';
  const talentId = ids.get('nkeng_sings') ?? '';
  const existingCalls = await db
    .select({ id: opportunities.id })
    .from(opportunities)
    .where(eq(opportunities.posterId, organiserId));

  if (existingCalls.length === 0) {
    const now = Date.now();
    const created: string[] = [];
    for (const call of CALLS) {
      const [row] = await db
        .insert(opportunities)
        .values({
          posterId: organiserId,
          title: call.title,
          description: call.description,
          categoryId: categories.get(call.talent) ?? '',
          city: call.city,
          country: 'CM',
          compensation: call.compensation,
          budgetAmount: call.budget ?? null,
          deadline: call.daysLeft
            ? new Date(now + call.daysLeft * DAY).toISOString().slice(0, 10)
            : null,
          featuredUntil: call.featuredDays ? new Date(now + call.featuredDays * DAY) : null,
        })
        .returning({ id: opportunities.id });
      if (row) created.push(row.id);
    }

    // The test talent has applied to the wedding call and been shortlisted.
    const weddingId = created[0];
    if (weddingId) {
      const [application] = await db
        .insert(applications)
        .values({
          opportunityId: weddingId,
          applicantId: talentId,
          message:
            'Bonjour ! Je chante makossa et afro-soul depuis huit ans, surtout pour des mariages. Mon live à Bonapriso est dans mon portfolio.',
          status: 'shortlisted',
        })
        .returning({ id: applications.id });
      await db
        .update(opportunities)
        .set({ applicationsCount: 1 })
        .where(eq(opportunities.id, weddingId));
      if (application) {
        await db.insert(notifications).values([
          {
            userId: organiserId,
            type: 'application_received',
            actorId: talentId,
            opportunityId: weddingId,
            applicationId: application.id,
          },
          {
            userId: talentId,
            type: 'application_status',
            actorId: organiserId,
            opportunityId: weddingId,
            applicationId: application.id,
          },
        ]);
      }
    }

    const followees = ['awa_danse', 'tchoko_comedy', 'dj_kribi'].flatMap((u) => {
      const id = ids.get(u);
      return id ? [id] : [];
    });
    await db
      .insert(follows)
      .values(followees.map((followeeId) => ({ followerId: talentId, followeeId })))
      .onConflictDoNothing();
    await db
      .insert(follows)
      .values({ followerId: organiserId, followeeId: talentId })
      .onConflictDoNothing();
    await db
      .insert(notifications)
      .values({ userId: talentId, type: 'new_follower', actorId: organiserId });
  }

  const existingPromos = await db
    .select({ id: promotions.id })
    .from(promotions)
    .where(inArray(promotions.placement, ['opportunities_feed']));
  if (existingPromos.length === 0) {
    await db.insert(promotions).values({
      sponsorName: 'Talanta',
      title: 'Votre premier appel est gratuit',
      body: 'Organisateurs, marques, réalisateurs : publiez une offre et recevez des candidatures de vrais talents.',
      ctaLabel: 'Publier une offre',
      url: 'talanta:post-call',
      placement: 'opportunities_feed',
      startsAt: new Date(Date.now() - DAY),
      endsAt: new Date(Date.now() + 90 * DAY),
    });
  }

  const postCount = await seedDemoPosts(db, ids, process.env.MEDIA_DIR ?? './storage/media');
  console.log(
    `Demo data ready: ${ids.size} people, ${CALLS.length} open calls, ${postCount} new posts.`,
  );
} finally {
  await pool.end();
}
