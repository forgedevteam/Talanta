import { eq } from 'drizzle-orm';
import { afterAll, beforeAll, describe, expect, it } from 'vitest';

import { users } from '../src/database/schema/index.js';
import {
  bearer,
  createTestApp,
  onboard,
  signIn,
  type Member,
  type TestApp,
} from './support/test-app.js';

describe('portfolio, discovery and following', () => {
  let app: TestApp;
  let singer: Member;
  let fan: Member;

  beforeAll(async () => {
    app = await createTestApp();
    singer = await onboard(app, { talent: 'music', city: 'Yaoundé' });
    fan = await onboard(app, { talent: 'dance', city: 'Douala' });
  });

  afterAll(async () => {
    await app.close();
  });

  describe('portfolio links', () => {
    it('stores a link and recognises the platform', async () => {
      const response = await app.http
        .post('/v1/me/portfolio')
        .set(...bearer(singer))
        .send({ title: 'Live at Institut Français', url: 'https://youtu.be/abc123' })
        .expect(201);

      expect(response.body).toMatchObject({ platform: 'youtube', url: 'https://youtu.be/abc123' });
    });

    it.each([
      ['http://youtube.com/watch?v=1', 'plain http'],
      ['javascript:alert(document.cookie)', 'a script'],
      ['https://user:pass@youtube.com/x', 'embedded credentials'],
      ['https://192.168.0.1/admin', 'a bare IP address'],
      ['https://localhost/x', 'a local host'],
      ['ftp://files.example.com/a', 'another protocol'],
    ])('refuses %s (%s)', async (url) => {
      const response = await app.http
        .post('/v1/me/portfolio')
        .set(...bearer(singer))
        .send({ title: 'Bad link', url })
        .expect(422);

      expect(response.body).toMatchObject({ code: 'link_not_allowed' });
    });

    it('lets people delete only their own pieces', async () => {
      const item = (
        await app.http
          .post('/v1/me/portfolio')
          .set(...bearer(singer))
          .send({ title: 'Studio session', url: 'https://audiomack.com/artist/song' })
          .expect(201)
      ).body as { id: string; platform: string };
      expect(item.platform).toBe('audiomack');

      await app.http
        .delete(`/v1/me/portfolio/${item.id}`)
        .set(...bearer(fan))
        .expect(404);
      await app.http
        .delete(`/v1/me/portfolio/${item.id}`)
        .set(...bearer(singer))
        .expect(204);
    });
  });

  describe('discovery', () => {
    it('finds creators by talent and city', async () => {
      const byTalent = (
        await app.http
          .get('/v1/creators?talent=music')
          .set(...bearer(fan))
          .expect(200)
      ).body as { items: { username: string }[] };
      expect(byTalent.items.map((c) => c.username)).toContain(singer.username);
      expect(byTalent.items.map((c) => c.username)).not.toContain(fan.username);

      const byCity = (
        await app.http
          .get('/v1/creators?city=yaoundé')
          .set(...bearer(fan))
          .expect(200)
      ).body as { items: { username: string }[] };
      expect(byCity.items.map((c) => c.username)).toEqual([singer.username]);
    });

    it('treats LIKE wildcards in a search as plain text', async () => {
      const response = (
        await app.http
          .get('/v1/creators?q=%25_')
          .set(...bearer(fan))
          .expect(200)
      ).body as {
        items: unknown[];
      };

      expect(response.items).toEqual([]);
    });

    it('shows a public profile with portfolio and counts', async () => {
      const response = await app.http
        .get(`/v1/creators/${singer.username}`)
        .set(...bearer(fan))
        .expect(200);

      expect(response.body).toMatchObject({
        username: singer.username,
        city: 'Yaoundé',
        isMe: false,
        isFollowing: false,
        primaryTalent: { slug: 'music' },
      });
      // Phone numbers and dates of birth never appear on public profiles.
      expect(JSON.stringify(response.body)).not.toContain(singer.phone);
      expect(response.body).not.toHaveProperty('dateOfBirth');
    });
  });

  describe('following', () => {
    it('follows, notifies once, and unfollows', async () => {
      const first = await app.http
        .post(`/v1/creators/${singer.username}/follow`)
        .set(...bearer(fan))
        .expect(200);
      expect(first.body).toEqual({ isFollowing: true, followerCount: 1 });
      await app.http
        .post(`/v1/creators/${singer.username}/follow`)
        .set(...bearer(fan))
        .expect(200);

      const notifications = (
        await app.http
          .get('/v1/me/notifications')
          .set(...bearer(singer))
          .expect(200)
      ).body as { items: { type: string }[] };
      expect(notifications.items.filter((n) => n.type === 'new_follower')).toHaveLength(1);
      const unread = await app.http
        .get('/v1/me/notifications/unread-count')
        .set(...bearer(singer))
        .expect(200);
      expect(unread.body).toEqual({ count: 1 });
      await app.http
        .post('/v1/me/notifications/read-all')
        .set(...bearer(singer))
        .expect(204);
      const after = await app.http
        .get('/v1/me/notifications/unread-count')
        .set(...bearer(singer))
        .expect(200);
      expect(after.body).toEqual({ count: 0 });

      const feed = (
        await app.http
          .get('/v1/feed/following')
          .set(...bearer(fan))
          .expect(200)
      ).body as {
        items: { creator: { username: string } }[];
      };
      expect(feed.items[0]?.creator.username).toBe(singer.username);

      const left = await app.http
        .delete(`/v1/creators/${singer.username}/follow`)
        .set(...bearer(fan))
        .expect(200);
      expect(left.body).toEqual({ isFollowing: false, followerCount: 0 });
    });

    it('does not let people follow themselves', async () => {
      await app.http
        .post(`/v1/creators/${fan.username}/follow`)
        .set(...bearer(fan))
        .expect(422);
    });
  });
});

describe('account security', () => {
  let app: TestApp;

  beforeAll(async () => {
    app = await createTestApp({
      OTP_TEST_NUMBERS: '+237699000001',
      OTP_TEST_CODE: '123456',
      THROTTLE_PER_USER_PER_MINUTE: '40',
    });
  });

  afterAll(async () => {
    await app.close();
  });

  it('signs a test account in with its fixed code and sends no SMS', async () => {
    const before = app.sms.sent.length;
    await app.http.post('/v1/auth/otp/request').send({ phone: '+237699000001' }).expect(200);

    await app.http
      .post('/v1/auth/otp/verify')
      .send({ phone: '+237699000001', code: '123456' })
      .expect(200);
    expect(app.sms.sent.length).toBe(before);
  });

  it('cuts off a suspended account at once, even with a valid access token', async () => {
    const member = await onboard(app);
    await app.http
      .get('/v1/me')
      .set(...bearer(member))
      .expect(200);

    await app.db.update(users).set({ status: 'suspended' }).where(eq(users.id, member.userId));

    await app.http
      .get('/v1/me')
      .set(...bearer(member))
      .expect(401);
  });

  it('uses the current role, not the one in the token', async () => {
    const member = await onboard(app);
    await app.db.update(users).set({ role: 'admin' }).where(eq(users.id, member.userId));
    await app.http
      .get('/v1/admin/reports')
      .set(...bearer(member))
      .expect(200);

    await app.db.update(users).set({ role: 'member' }).where(eq(users.id, member.userId));

    await app.http
      .get('/v1/admin/reports')
      .set(...bearer(member))
      .expect(404);
  });

  it('throttles one user making too many requests', async () => {
    const member = await signIn(app);
    let limited = false;
    for (let i = 0; i < 45 && !limited; i += 1) {
      const response = await app.http.get('/v1/me').set(...bearer(member));
      limited = response.status === 429;
    }
    expect(limited).toBe(true);
  });

  it('refuses oversized request bodies', async () => {
    const member = await signIn(app);
    await app.http
      .put('/v1/me/profile')
      .set(...bearer(member))
      .send({ displayName: 'x'.repeat(70_000), username: 'big', city: 'Douala' })
      .expect(413);
  });

  it('deletes an account: identity cleared, sessions ended, number free again', async () => {
    const member = await onboard(app);
    await app.http
      .post('/v1/me/portfolio')
      .set(...bearer(member))
      .send({ title: 'My best work', url: 'https://www.tiktok.com/@me/video/1' })
      .expect(201);

    await app.http
      .delete('/v1/me')
      .set(...bearer(member))
      .expect(204);

    await app.http
      .get('/v1/me')
      .set(...bearer(member))
      .expect(401);
    await app.http.post('/v1/auth/refresh').send({ refreshToken: member.refreshToken }).expect(401);
    await app.http
      .get(`/v1/creators/${member.username}`)
      .set(...bearer(await signIn(app)))
      .expect(404);
    const [row] = await app.db.select().from(users).where(eq(users.id, member.userId));
    expect(row).toMatchObject({ status: 'deleted', phone: null, dateOfBirth: null });
  });

  it('limits code guesses from one IP across many numbers', async () => {
    const strict = await createTestApp({ OTP_MAX_VERIFY_PER_IP_PER_HOUR: '3' });
    try {
      let last = 0;
      for (let i = 0; i < 4; i += 1) {
        const response = await strict.http
          .post('/v1/auth/otp/verify')
          .send({ phone: `+23767100000${i}`, code: '000000' });
        last = response.status;
      }
      expect(last).toBe(429);
    } finally {
      await strict.close();
    }
  });
});
