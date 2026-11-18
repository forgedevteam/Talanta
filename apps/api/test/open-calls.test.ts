import { eq } from 'drizzle-orm';
import { afterAll, beforeAll, describe, expect, it } from 'vitest';

import { users } from '../src/database/schema/index.js';
import {
  bearer,
  categoryId,
  createTestApp,
  onboard,
  signIn,
  type Member,
  type TestApp,
} from './support/test-app.js';

interface Summary {
  id: string;
  title: string;
  isFeatured: boolean;
  applicationsCount: number;
  poster: { username: string } | null;
}

describe('Open Calls', () => {
  let app: TestApp;
  let organiser: Member;
  let talent: Member;
  let musicId: string;

  beforeAll(async () => {
    app = await createTestApp();
    organiser = await onboard(app, { talent: 'film' });
    talent = await onboard(app, { talent: 'music' });
    musicId = await categoryId(app, 'music');
  });

  afterAll(async () => {
    await app.close();
  });

  const post = (who: Member, overrides: object = {}) =>
    app.http
      .post('/v1/opportunities')
      .set(...bearer(who))
      .send({
        title: 'Singer for a wedding reception in Douala',
        description: 'Three sets of makossa and bikutsi classics, 7pm to midnight, sound provided.',
        categoryId: musicId,
        city: 'Douala',
        compensation: 'paid',
        budgetAmount: 150000,
        ...overrides,
      });

  describe('posting', () => {
    it('creates a call in the poster’s country with them as poster', async () => {
      const response = await post(organiser).expect(201);

      expect(response.body).toMatchObject({
        title: 'Singer for a wedding reception in Douala',
        category: { slug: 'music' },
        compensation: 'paid',
        budgetAmount: 150000,
        currency: 'XAF',
        status: 'open',
        isMine: true,
        isFeatured: false,
        poster: { username: organiser.username },
      });
    });

    it('requires an amount for paid work', async () => {
      const response = await post(organiser, { budgetAmount: undefined }).expect(422);

      expect(response.body).toHaveProperty('fields.budgetAmount');
    });

    it('is for adults only', async () => {
      const minor = await onboard(app, { dateOfBirth: '2010-01-01' });

      const response = await post(minor).expect(403);

      expect(response.body).toMatchObject({ code: 'adults_only' });
    });

    it('needs a finished profile', async () => {
      const fresh = await signIn(app);

      const response = await app.http
        .post('/v1/opportunities')
        .set(...bearer(fresh))
        .send({
          title: 'Dancers for a music video',
          description: 'Six dancers for a one-day shoot in Bonapriso, choreography provided.',
          categoryId: musicId,
          city: 'Douala',
          compensation: 'negotiable',
        })
        .expect(409);

      expect(response.body).toMatchObject({ code: 'profile_required' });
    });

    it('refuses a closing date in the past', async () => {
      const response = await post(organiser, { deadline: '2020-01-01' }).expect(422);

      expect(response.body).toHaveProperty('fields.deadline');
    });

    it('limits posting to five calls a day', async () => {
      const busy = await onboard(app);
      for (let i = 0; i < 5; i += 1) await post(busy).expect(201);

      const response = await post(busy).expect(429);

      expect(response.body).toMatchObject({ code: 'rate_limited' });
    });
  });

  describe('the feed', () => {
    it('lists open calls newest first and filters by talent', async () => {
      const created = (
        await post(organiser, { title: 'Bikutsi band for a launch party' }).expect(201)
      ).body as Summary;

      const all = (
        await app.http
          .get('/v1/opportunities')
          .set(...bearer(talent))
          .expect(200)
      ).body as {
        items: Summary[];
      };
      expect(all.items[0]?.id).toBe(created.id);

      const film = (
        await app.http
          .get('/v1/opportunities?category=film')
          .set(...bearer(talent))
          .expect(200)
      ).body as { items: Summary[] };
      expect(film.items.find((item) => item.id === created.id)).toBeUndefined();
    });

    it('pages with a cursor and never repeats a call', async () => {
      const first = (
        await app.http
          .get('/v1/opportunities?limit=2')
          .set(...bearer(talent))
          .expect(200)
      ).body as { items: Summary[]; nextCursor: string };
      const second = (
        await app.http
          .get(`/v1/opportunities?limit=2&cursor=${first.nextCursor}`)
          .set(...bearer(talent))
          .expect(200)
      ).body as { items: Summary[] };

      const ids = [...first.items, ...second.items].map((item) => item.id);
      expect(new Set(ids).size).toBe(ids.length);
    });

    it('treats wildcards in the city filter as plain text', async () => {
      const response = (
        await app.http
          .get('/v1/opportunities?city=%25')
          .set(...bearer(talent))
          .expect(200)
      ).body as { items: Summary[] };

      expect(response.items).toEqual([]);
    });
  });

  describe('applying', () => {
    let callId: string;

    beforeAll(async () => {
      callId = (
        (await post(organiser, { title: 'MC for a bilingual concert in Buea' }).expect(201))
          .body as Summary
      ).id;
    });

    it('records the application, counts it and tells the poster', async () => {
      const response = await app.http
        .post(`/v1/opportunities/${callId}/applications`)
        .set(...bearer(talent))
        .send({ message: 'I host in English and French and have done 40 events this year.' })
        .expect(201);

      expect(response.body).toMatchObject({
        applicationsCount: 1,
        myApplication: { status: 'submitted' },
        isMine: false,
      });

      const notifications = (
        await app.http
          .get('/v1/me/notifications')
          .set(...bearer(organiser))
          .expect(200)
      ).body as {
        items: { type: string; actor: { username: string }; opportunityTitle: string }[];
      };
      expect(notifications.items[0]).toMatchObject({
        type: 'application_received',
        actor: { username: talent.username },
        opportunityTitle: 'MC for a bilingual concert in Buea',
      });
    });

    it('allows one application per person', async () => {
      const response = await app.http
        .post(`/v1/opportunities/${callId}/applications`)
        .set(...bearer(talent))
        .send({ message: 'Applying a second time to be sure.' })
        .expect(409);

      expect(response.body).toMatchObject({ code: 'already_applied' });
    });

    it('does not let posters apply to their own call', async () => {
      const response = await app.http
        .post(`/v1/opportunities/${callId}/applications`)
        .set(...bearer(organiser))
        .send({ message: 'Testing my own call here.' })
        .expect(422);

      expect(response.body).toMatchObject({ code: 'cannot_apply_to_own' });
    });

    it('does not let minors apply', async () => {
      const minor = await onboard(app, { dateOfBirth: '2011-06-01' });

      await app.http
        .post(`/v1/opportunities/${callId}/applications`)
        .set(...bearer(minor))
        .send({ message: 'I would love to do this event.' })
        .expect(403);
    });

    it('refuses a portfolio piece that belongs to someone else', async () => {
      const other = await onboard(app);
      const theirs = (
        await app.http
          .post('/v1/me/portfolio')
          .set(...bearer(other))
          .send({ title: 'Their live set', url: 'https://www.youtube.com/watch?v=abc123' })
          .expect(201)
      ).body as { id: string };
      const applicant = await onboard(app);

      await app.http
        .post(`/v1/opportunities/${callId}/applications`)
        .set(...bearer(applicant))
        .send({ message: 'Here is my best work.', portfolioItemId: theirs.id })
        .expect(422);
    });

    it('shows applicants only to the poster', async () => {
      const own = await app.http
        .get(`/v1/opportunities/${callId}/applications`)
        .set(...bearer(organiser))
        .expect(200);
      expect(own.body).toHaveLength(1);

      // Anyone else, even another applicant, cannot see the list or learn it exists.
      const snoop = await app.http
        .get(`/v1/opportunities/${callId}/applications`)
        .set(...bearer(talent))
        .expect(404);
      expect(snoop.body).toMatchObject({ code: 'not_found' });
    });

    it('lets only the poster change a status, and tells the applicant', async () => {
      const [application] = (
        await app.http
          .get(`/v1/opportunities/${callId}/applications`)
          .set(...bearer(organiser))
          .expect(200)
      ).body as { applicationId: string }[];
      const id = application?.applicationId ?? '';

      await app.http
        .patch(`/v1/applications/${id}`)
        .set(...bearer(talent))
        .send({ status: 'hired' })
        .expect(404);

      const response = await app.http
        .patch(`/v1/applications/${id}`)
        .set(...bearer(organiser))
        .send({ status: 'shortlisted' })
        .expect(200);
      expect(response.body).toMatchObject({ status: 'shortlisted' });

      const mine = (
        await app.http
          .get('/v1/me/applications')
          .set(...bearer(talent))
          .expect(200)
      ).body as {
        status: string;
        opportunity: { id: string };
      }[];
      expect(mine.find((a) => a.opportunity.id === callId)?.status).toBe('shortlisted');

      const notifications = (
        await app.http
          .get('/v1/me/notifications')
          .set(...bearer(talent))
          .expect(200)
      ).body as { items: { type: string; applicationStatus: string }[] };
      expect(notifications.items[0]).toMatchObject({
        type: 'application_status',
        applicationStatus: 'shortlisted',
      });
    });

    it('stops taking applications once closed, and only the poster can close it', async () => {
      await app.http
        .post(`/v1/opportunities/${callId}/close`)
        .set(...bearer(talent))
        .expect(404);
      await app.http
        .post(`/v1/opportunities/${callId}/close`)
        .set(...bearer(organiser))
        .expect(200);
      const late = await onboard(app);

      const response = await app.http
        .post(`/v1/opportunities/${callId}/applications`)
        .set(...bearer(late))
        .send({ message: 'Sorry I am late to this one.' })
        .expect(409);

      expect(response.body).toMatchObject({ code: 'opportunity_closed' });
    });
  });

  describe('featured placement and admin tools', () => {
    let admin: Member;
    let poster: Member;

    beforeAll(async () => {
      poster = await onboard(app);
      admin = await onboard(app);
      await app.db.update(users).set({ role: 'admin' }).where(eq(users.id, admin.userId));
    });

    it('hides admin routes from everyone else', async () => {
      const call = (await post(poster).expect(201)).body as Summary;

      const response = await app.http
        .post(`/v1/admin/opportunities/${call.id}/feature`)
        .set(...bearer(poster))
        .send({ days: 7 })
        .expect(404);

      expect(response.body).toMatchObject({ code: 'not_found' });
    });

    it('lets an admin take a call down', async () => {
      const call = (await post(poster, { title: 'Pay 20,000 to audition for a film' }).expect(201))
        .body as Summary;

      await app.http
        .post(`/v1/admin/opportunities/${call.id}/remove`)
        .set(...bearer(admin))
        .expect(204);

      await app.http
        .get(`/v1/opportunities/${call.id}`)
        .set(...bearer(talent))
        .expect(404);
    });

    it('takes reports and shows them to admins', async () => {
      const call = (await post(poster).expect(201)).body as Summary;
      await app.http
        .post('/v1/reports')
        .set(...bearer(talent))
        .send({
          targetType: 'opportunity',
          targetId: call.id,
          reason: 'scam',
          details: 'Asked me to pay a fee.',
        })
        .expect(204);
      // Reporting twice is harmless.
      await app.http
        .post('/v1/reports')
        .set(...bearer(talent))
        .send({ targetType: 'opportunity', targetId: call.id, reason: 'scam' })
        .expect(204);

      const queue = (
        await app.http
          .get('/v1/admin/reports')
          .set(...bearer(admin))
          .expect(200)
      ).body as {
        targetId: string;
      }[];
      expect(queue.filter((r) => r.targetId === call.id)).toHaveLength(1);
      await app.http
        .get('/v1/admin/reports')
        .set(...bearer(talent))
        .expect(404);
    });

    it('shows running sponsored cards', async () => {
      const now = app.clock.now();
      await app.http
        .post('/v1/admin/promotions')
        .set(...bearer(admin))
        .send({
          placement: 'opportunities_feed',
          sponsorName: 'Talanta',
          title: 'Feature your call',
          body: 'Get seen first by creators across Cameroon.',
          ctaLabel: 'Learn more',
          url: 'talanta:post-call',
          startsAt: new Date(now.getTime() - 1000).toISOString(),
          endsAt: new Date(now.getTime() + 86_400_000).toISOString(),
        })
        .expect(201);

      const cards = (
        await app.http
          .get('/v1/promotions?placement=opportunities_feed')
          .set(...bearer(talent))
          .expect(200)
      ).body as { title: string }[];
      expect(cards[0]).toMatchObject({ title: 'Feature your call' });
    });

    it('rejects sponsored links that are not https', async () => {
      await app.http
        .post('/v1/admin/promotions')
        .set(...bearer(admin))
        .send({
          placement: 'opportunities_feed',
          sponsorName: 'Bad',
          title: 'Click',
          body: 'Click here',
          ctaLabel: 'Go',
          url: 'javascript:alert(1)',
          startsAt: new Date().toISOString(),
          endsAt: new Date(Date.now() + 1000).toISOString(),
        })
        .expect(422);
    });

    it('puts a featured call in its own row on the first page', async () => {
      const call = (await post(poster, { title: 'Actors for a TV advert in Yaoundé' }).expect(201))
        .body as Summary;

      await app.http
        .post(`/v1/admin/opportunities/${call.id}/feature`)
        .set(...bearer(admin))
        .send({ days: 7 })
        .expect(200);

      const feed = (
        await app.http
          .get('/v1/opportunities')
          .set(...bearer(talent))
          .expect(200)
      ).body as {
        featured: Summary[];
        items: Summary[];
      };
      expect(feed.featured.map((f) => f.id)).toContain(call.id);
      expect(feed.featured[0]?.isFeatured).toBe(true);
      expect(feed.items.map((i) => i.id)).not.toContain(call.id);

      // The featured row expires on its own.
      // Last test in the file: jumping the clock expires everyone's access token.
      app.clock.advance(8 * 86_400);
      const viewer = await signIn(app);
      const later = (
        await app.http
          .get('/v1/opportunities')
          .set(...bearer(viewer))
          .expect(200)
      ).body as {
        featured: Summary[];
      };
      expect(later.featured.map((f) => f.id)).not.toContain(call.id);
    });
  });
});
