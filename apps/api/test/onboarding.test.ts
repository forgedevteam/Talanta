import { afterAll, beforeAll, describe, expect, it } from 'vitest';

import { bearer, createTestApp, signIn, type SignedIn, type TestApp } from './support/test-app.js';

interface Category {
  id: string;
  slug: string;
  name: string;
  icon: string;
}

describe('onboarding', () => {
  let app: TestApp;
  let categories: Category[];

  beforeAll(async () => {
    app = await createTestApp();
    const response = await app.http.get('/v1/talent-categories').expect(200);
    categories = response.body as Category[];
  });

  afterAll(async () => {
    await app.close();
  });

  const idOf = (slug: string): string => {
    const category = categories.find((candidate) => candidate.slug === slug);
    if (!category) throw new Error(`No category "${slug}"`);
    return category.id;
  };

  const setTalents = (session: SignedIn, body: object) =>
    app.http
      .put('/v1/me/talents')
      .set(...bearer(session))
      .send(body);

  const saveProfile = (session: SignedIn, body: object) =>
    app.http
      .put('/v1/me/profile')
      .set(...bearer(session))
      .send(body);

  describe('talent categories', () => {
    it('are public, ordered and cacheable', async () => {
      const response = await app.http.get('/v1/talent-categories').expect(200);

      expect(categories.slice(0, 3).map((category) => category.slug)).toEqual([
        'music',
        'dance',
        'acting',
      ]);
      expect(categories).toHaveLength(12);
      expect(response.headers['cache-control']).toContain('max-age=300');
    });
  });

  describe('picking talents', () => {
    it('saves the picks, makes the first one the main talent and moves on to the profile step', async () => {
      const session = await signIn(app);

      const response = await setTalents(session, {
        categoryIds: [idOf('dance'), idOf('music')],
      }).expect(200);

      expect(response.body).toMatchObject({
        onboardingStep: 'profile',
        talents: [
          { slug: 'dance', isPrimary: true, level: 'emerging' },
          { slug: 'music', isPrimary: false },
        ],
      });
    });

    it('replaces earlier picks and can change the main talent', async () => {
      const session = await signIn(app);
      await setTalents(session, { categoryIds: [idOf('dance'), idOf('music')] }).expect(200);

      const response = await setTalents(session, {
        categoryIds: [idOf('music'), idOf('comedy')],
        primaryCategoryId: idOf('comedy'),
      }).expect(200);

      const talents = (response.body as { talents: { slug: string; isPrimary: boolean }[] })
        .talents;
      expect(talents).toEqual([
        expect.objectContaining({ slug: 'comedy', isPrimary: true }),
        expect.objectContaining({ slug: 'music', isPrimary: false }),
      ]);
    });

    it('needs at least one talent and allows at most five', async () => {
      const session = await signIn(app);

      const none = await setTalents(session, { categoryIds: [] }).expect(422);
      expect(none.body).toHaveProperty('fields.categoryIds');

      const six = categories.slice(0, 6).map((category) => category.id);
      await setTalents(session, { categoryIds: six }).expect(422);
    });

    it('rejects a category that does not exist', async () => {
      const session = await signIn(app);

      const response = await setTalents(session, {
        categoryIds: ['01939c4e-7a2b-7c3d-8e4f-5a6b7c8d9e0f'],
      }).expect(422);

      expect(response.body).toMatchObject({ code: 'talent_category_unknown' });
    });

    it('rejects a main talent that was not picked', async () => {
      const session = await signIn(app);

      const response = await setTalents(session, {
        categoryIds: [idOf('music')],
        primaryCategoryId: idOf('film'),
      }).expect(422);

      expect(response.body).toHaveProperty('fields.primaryCategoryId');
    });

    it('needs a signed-in user', async () => {
      await app.http
        .put('/v1/me/talents')
        .send({ categoryIds: [idOf('music')] })
        .expect(401);
    });
  });

  describe('creating a profile', () => {
    it('tidies the input, saves it and finishes onboarding', async () => {
      const session = await signIn(app);
      await setTalents(session, { categoryIds: [idOf('spoken-word')] }).expect(200);

      const response = await saveProfile(session, {
        displayName: '  Amara   Okafor ',
        username: 'Amara_Sings',
        city: ' Lagos ',
      }).expect(200);

      expect(response.body).toMatchObject({
        onboardingStep: 'done',
        profile: {
          displayName: 'Amara Okafor',
          username: 'amara_sings',
          city: 'Lagos',
          bio: null,
          avatarUrl: null,
          isVerified: false,
        },
      });
    });

    it('lets the owner edit their profile and keep their username', async () => {
      const session = await signIn(app);
      await saveProfile(session, {
        displayName: 'Kwame',
        username: 'kwame_draws',
        city: 'Accra',
      }).expect(200);

      const response = await saveProfile(session, {
        displayName: 'Kwame Mensah',
        username: 'kwame_draws',
        city: 'Kumasi',
        bio: 'Charcoal portraits.',
      }).expect(200);

      expect(response.body).toMatchObject({
        profile: { displayName: 'Kwame Mensah', city: 'Kumasi', bio: 'Charcoal portraits.' },
      });
    });

    it('refuses a username someone else holds, whatever the letter case', async () => {
      const first = await signIn(app);
      const second = await signIn(app);
      await saveProfile(first, {
        displayName: 'Wanjiru',
        username: 'wanjiru',
        city: 'Nairobi',
      }).expect(200);

      const response = await saveProfile(second, {
        displayName: 'Another Wanjiru',
        username: 'WANJIRU',
        city: 'Mombasa',
      }).expect(409);

      expect(response.body).toMatchObject({ code: 'username_taken' });
    });

    it('refuses reserved usernames', async () => {
      const session = await signIn(app);

      const response = await saveProfile(session, {
        displayName: 'Not Staff',
        username: 'talanta',
        city: 'Lagos',
      }).expect(409);

      expect(response.body).toMatchObject({ code: 'username_reserved' });
    });

    it('explains every invalid field at once', async () => {
      const session = await signIn(app);

      const response = await saveProfile(session, {
        displayName: 'A',
        username: 'no spaces!',
        city: '',
      }).expect(422);

      const fields = (response.body as { fields: Record<string, string[]> }).fields;
      expect(Object.keys(fields).sort()).toEqual(['city', 'displayName', 'username']);
    });
  });

  describe('username availability', () => {
    it('tells available, taken and reserved apart', async () => {
      const holder = await signIn(app);
      const asker = await signIn(app);
      await saveProfile(holder, {
        displayName: 'Thandi',
        username: 'thandi_moves',
        city: 'Durban',
      }).expect(200);

      const check = async (session: SignedIn, username: string): Promise<string> => {
        const response = await app.http
          .get('/v1/profiles/username-availability')
          .query({ username })
          .set(...bearer(session))
          .expect(200);
        return (response.body as { status: string }).status;
      };

      expect(await check(asker, 'fresh_name')).toBe('available');
      expect(await check(asker, 'Thandi_Moves')).toBe('taken');
      expect(await check(asker, 'admin')).toBe('reserved');
      expect(await check(holder, 'thandi_moves')).toBe('available');
    });

    it('rejects names that break the rules', async () => {
      const session = await signIn(app);

      await app.http
        .get('/v1/profiles/username-availability')
        .query({ username: 'a' })
        .set(...bearer(session))
        .expect(422);
    });
  });
});

describe('health', () => {
  let app: TestApp;

  beforeAll(async () => {
    app = await createTestApp();
  });

  afterAll(async () => {
    await app.close();
  });

  it('answers liveness and readiness without a token or version prefix', async () => {
    await app.http.get('/health').expect(200, { status: 'ok' });
    await app.http.get('/health/ready').expect(200, { status: 'ok' });
  });
});
