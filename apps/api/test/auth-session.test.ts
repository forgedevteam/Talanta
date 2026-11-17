import { eq } from 'drizzle-orm';
import { afterAll, beforeAll, describe, expect, it } from 'vitest';

import { users } from '../src/database/schema/index.js';
import { bearer, createTestApp, signIn, type TestApp } from './support/test-app.js';

interface TokenPair {
  accessToken: string;
  refreshToken: string;
  accessTokenExpiresIn: number;
}

describe('sessions', () => {
  let app: TestApp;

  beforeAll(async () => {
    app = await createTestApp();
  });

  afterAll(async () => {
    await app.close();
  });

  const refresh = (refreshToken: string) =>
    app.http.post('/v1/auth/refresh').send({ refreshToken });

  describe('access tokens', () => {
    it('open private routes', async () => {
      const session = await signIn(app);

      const response = await app.http
        .get('/v1/me')
        .set(...bearer(session))
        .expect(200);

      expect(response.body).toMatchObject({ id: session.userId, phone: session.phone });
    });

    it('are required on private routes', async () => {
      const response = await app.http.get('/v1/me').expect(401);

      expect(response.body).toMatchObject({ code: 'unauthorized' });
    });

    it('are rejected when tampered with', async () => {
      const session = await signIn(app);
      const forged = `${session.accessToken.slice(0, -4)}AAAA`;

      await app.http.get('/v1/me').set('Authorization', `Bearer ${forged}`).expect(401);
    });

    it('stop working after fifteen minutes', async () => {
      const session = await signIn(app);

      app.clock.advance(14 * 60);
      await app.http
        .get('/v1/me')
        .set(...bearer(session))
        .expect(200);

      app.clock.advance(2 * 60);
      await app.http
        .get('/v1/me')
        .set(...bearer(session))
        .expect(401);
    });
  });

  describe('refresh tokens', () => {
    it('are exchanged for a new working pair', async () => {
      const session = await signIn(app);
      app.clock.advance(16 * 60);

      const response = await refresh(session.refreshToken).expect(200);
      const pair = response.body as TokenPair;

      expect(pair.refreshToken).not.toBe(session.refreshToken);
      await app.http.get('/v1/me').set('Authorization', `Bearer ${pair.accessToken}`).expect(200);
    });

    it('can be retried for a few seconds, for when the response got lost', async () => {
      const session = await signIn(app);
      await refresh(session.refreshToken).expect(200);

      app.clock.advance(5);
      const retry = await refresh(session.refreshToken).expect(200);

      // The pair from the retry carries the session forward.
      await refresh((retry.body as TokenPair).refreshToken).expect(200);
    });

    it('revoke the whole session when a spent token comes back later', async () => {
      const session = await signIn(app);
      const rotated = await refresh(session.refreshToken).expect(200);
      const current = (rotated.body as TokenPair).refreshToken;

      app.clock.advance(60);
      const replay = await refresh(session.refreshToken).expect(401);
      expect(replay.body).toMatchObject({ code: 'session_expired' });

      // The legitimate holder is signed out too: we cannot tell who is who.
      await refresh(current).expect(401);
    });

    it('expire after sixty days without use', async () => {
      const session = await signIn(app);

      app.clock.advance(61 * 86_400);

      const response = await refresh(session.refreshToken).expect(401);
      expect(response.body).toMatchObject({ code: 'session_expired' });
    });

    it('are rejected when the secret half is wrong', async () => {
      const session = await signIn(app);
      const [id] = session.refreshToken.split('.');

      await refresh(`${id}.${'x'.repeat(43)}`).expect(401);
      // A wrong guess must not disturb the real session.
      await refresh(session.refreshToken).expect(200);
    });

    it('are rejected when malformed', async () => {
      await refresh('not-a-token-not-a-token-not-a-token-not-a-token').expect(401);
      await refresh('short').expect(422);
    });

    it('stop working for a suspended account', async () => {
      const session = await signIn(app);
      await app.db.update(users).set({ status: 'suspended' }).where(eq(users.id, session.userId));

      const response = await refresh(session.refreshToken).expect(403);

      expect(response.body).toMatchObject({ code: 'account_suspended' });
    });

    it('do not affect other sessions of the same person', async () => {
      const phone = { national: '08039990001', e164: '+2348039990001' };
      const phoneSession = await signIn(app, phone);
      app.clock.advance(61);
      const tabletSession = await signIn(app, phone);

      await app.http
        .post('/v1/auth/logout')
        .send({ refreshToken: phoneSession.refreshToken })
        .expect(204);

      await refresh(phoneSession.refreshToken).expect(401);
      await refresh(tabletSession.refreshToken).expect(200);
    });
  });

  describe('signing out', () => {
    it('ends the session', async () => {
      const session = await signIn(app);

      await app.http
        .post('/v1/auth/logout')
        .send({ refreshToken: session.refreshToken })
        .expect(204);

      await refresh(session.refreshToken).expect(401);
    });

    it('succeeds quietly for a token that is already dead', async () => {
      const session = await signIn(app);
      await app.http
        .post('/v1/auth/logout')
        .send({ refreshToken: session.refreshToken })
        .expect(204);

      await app.http
        .post('/v1/auth/logout')
        .send({ refreshToken: session.refreshToken })
        .expect(204);
    });
  });

  it('refuses sign-in to a suspended account', async () => {
    const phone = { national: '08039990002', e164: '+2348039990002' };
    const session = await signIn(app, phone);
    await app.db.update(users).set({ status: 'suspended' }).where(eq(users.id, session.userId));
    app.clock.advance(61);

    await app.http.post('/v1/auth/otp/request').send({ phone: phone.e164 }).expect(200);
    const response = await app.http
      .post('/v1/auth/otp/verify')
      .send({ phone: phone.e164, code: app.sms.lastCodeFor(phone.e164) })
      .expect(403);

    expect(response.body).toMatchObject({ code: 'account_suspended' });
  });
});
