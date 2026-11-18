import { afterAll, beforeAll, describe, expect, it } from 'vitest';

import { createTestApp, nextPhone, type TestApp } from './support/test-app.js';

describe('phone sign-in', () => {
  let app: TestApp;

  beforeAll(async () => {
    app = await createTestApp();
  });

  afterAll(async () => {
    await app.close();
  });

  const requestCode = (phone: string, country?: string) =>
    app.http.post('/v1/auth/otp/request').send({ phone, country });

  const verifyCode = (phone: string, code: string) =>
    app.http.post('/v1/auth/otp/verify').send({ phone, code });

  describe('requesting a code', () => {
    it('normalises a national number and texts a six-digit code', async () => {
      const phone = nextPhone();

      const response = await requestCode(phone.national, 'NG').expect(200);

      expect(response.body).toEqual({
        phone: phone.e164,
        displayPhone: expect.stringMatching(/^\+234 803 /) as unknown,
        expiresInSeconds: 300,
        resendAfterSeconds: 60,
      });
      expect(app.sms.lastCodeFor(phone.e164)).toMatch(/^\d{6}$/);
    });

    it('accepts numbers from each launch country', async () => {
      for (const number of ['+237671234567', '+254712345678', '+233241234567', '+27821234567']) {
        await requestCode(number).expect(200);
      }
    });

    it('rejects a number that cannot exist', async () => {
      const response = await requestCode('12345', 'NG').expect(422);

      expect(response.body).toMatchObject({ code: 'phone_invalid' });
    });

    it('rejects a valid number from a country we have not launched in', async () => {
      const response = await requestCode('+447400123456').expect(422);

      expect(response.body).toMatchObject({ code: 'phone_country_unsupported' });
    });

    it('reports missing fields by name', async () => {
      const response = await app.http.post('/v1/auth/otp/request').send({}).expect(422);

      expect(response.body).toMatchObject({ code: 'validation_failed' });
      expect(response.body).toHaveProperty('fields.phone');
    });

    it('refuses unknown properties', async () => {
      const phone = nextPhone();

      const response = await app.http
        .post('/v1/auth/otp/request')
        .send({ phone: phone.e164, role: 'admin' })
        .expect(422);

      expect(response.body).toMatchObject({ code: 'validation_failed' });
    });

    it('makes the person wait a minute before a resend', async () => {
      const phone = nextPhone();
      await requestCode(phone.e164).expect(200);

      app.clock.advance(15);
      const tooSoon = await requestCode(phone.e164).expect(429);
      expect(tooSoon.body).toMatchObject({ code: 'otp_resend_too_soon', retryAfterSeconds: 45 });
      expect(tooSoon.headers['retry-after']).toBe('45');
      expect(app.sms.sent.filter((message) => message.to === phone.e164)).toHaveLength(1);

      app.clock.advance(46);
      await requestCode(phone.e164).expect(200);
    });

    it('caps the codes one number can receive in an hour', async () => {
      const phone = nextPhone();
      for (let sent = 0; sent < 5; sent += 1) {
        await requestCode(phone.e164).expect(200);
        app.clock.advance(61);
      }

      const response = await requestCode(phone.e164).expect(429);
      expect(response.body).toMatchObject({ code: 'otp_rate_limited' });

      app.clock.advance(3600);
      await requestCode(phone.e164).expect(200);
    });

    it('lets the person retry at once when the gateway fails', async () => {
      const phone = nextPhone();
      app.sms.failNext = true;

      const failed = await requestCode(phone.e164).expect(502);
      expect(failed.body).toMatchObject({ code: 'sms_delivery_failed' });

      await requestCode(phone.e164).expect(200);
    });
  });

  describe('verifying a code', () => {
    it('creates the account on first sign-in and returns a session', async () => {
      const phone = nextPhone();
      await requestCode(phone.e164).expect(200);

      const response = await verifyCode(phone.e164, app.sms.lastCodeFor(phone.e164)).expect(200);

      expect(response.body).toMatchObject({
        isNewUser: true,
        tokens: { accessTokenExpiresIn: 900 },
        me: {
          phone: phone.e164,
          country: 'NG',
          role: 'member',
          profile: null,
          talents: [],
          onboardingStep: 'talents',
        },
      });
    });

    it('signs the same person in again without creating a second account', async () => {
      const phone = nextPhone();
      await requestCode(phone.e164).expect(200);
      const first = await verifyCode(phone.e164, app.sms.lastCodeFor(phone.e164)).expect(200);

      app.clock.advance(61);
      await requestCode(phone.e164).expect(200);
      const second = await verifyCode(phone.e164, app.sms.lastCodeFor(phone.e164)).expect(200);

      expect(second.body).toMatchObject({
        isNewUser: false,
        me: { id: (first.body as { me: { id: string } }).me.id },
      });
    });

    it('rejects a wrong code and still accepts the right one afterwards', async () => {
      const phone = nextPhone();
      await requestCode(phone.e164).expect(200);
      const code = app.sms.lastCodeFor(phone.e164);
      const wrong = code === '000000' ? '111111' : '000000';

      const response = await verifyCode(phone.e164, wrong).expect(400);
      expect(response.body).toMatchObject({ code: 'otp_invalid' });

      await verifyCode(phone.e164, code).expect(200);
    });

    it('burns the code after five wrong tries', async () => {
      const phone = nextPhone();
      await requestCode(phone.e164).expect(200);
      const code = app.sms.lastCodeFor(phone.e164);
      const wrong = code === '000000' ? '111111' : '000000';

      for (let attempt = 0; attempt < 4; attempt += 1) {
        await verifyCode(phone.e164, wrong).expect(400);
      }
      const locked = await verifyCode(phone.e164, wrong).expect(429);
      expect(locked.body).toMatchObject({ code: 'otp_too_many_attempts' });

      const afterwards = await verifyCode(phone.e164, code).expect(400);
      expect(afterwards.body).toMatchObject({ code: 'otp_expired' });
    });

    it('rejects a code after it expires', async () => {
      const phone = nextPhone();
      await requestCode(phone.e164).expect(200);
      const code = app.sms.lastCodeFor(phone.e164);

      app.clock.advance(301);

      const response = await verifyCode(phone.e164, code).expect(400);
      expect(response.body).toMatchObject({ code: 'otp_expired' });
    });

    it('accepts a code only once', async () => {
      const phone = nextPhone();
      await requestCode(phone.e164).expect(200);
      const code = app.sms.lastCodeFor(phone.e164);

      await verifyCode(phone.e164, code).expect(200);
      await verifyCode(phone.e164, code).expect(400);
    });

    it('does not accept one number’s code for another number', async () => {
      const mine = nextPhone();
      const theirs = nextPhone();
      await requestCode(mine.e164).expect(200);
      await requestCode(theirs.e164).expect(200);

      const myCode = app.sms.lastCodeFor(mine.e164);
      const theirCode = app.sms.lastCodeFor(theirs.e164);
      // Equal codes would make the assertion meaningless; the odds are one in a million.
      if (myCode !== theirCode) {
        await verifyCode(theirs.e164, myCode).expect(400);
      }
    });
  });
});

describe('request limit per IP address', () => {
  let app: TestApp;

  beforeAll(async () => {
    app = await createTestApp({ OTP_MAX_PER_IP_PER_HOUR: '3' });
  });

  afterAll(async () => {
    await app.close();
  });

  it('stops one address from requesting codes for many numbers', async () => {
    for (let sent = 0; sent < 3; sent += 1) {
      await app.http.post('/v1/auth/otp/request').send({ phone: nextPhone().e164 }).expect(200);
    }

    const response = await app.http
      .post('/v1/auth/otp/request')
      .send({ phone: nextPhone().e164 })
      .expect(429);

    expect(response.body).toMatchObject({ code: 'otp_rate_limited' });
    expect(Number(response.headers['retry-after'])).toBeGreaterThan(0);
  });
});

describe('fixed development code', () => {
  let app: TestApp;

  beforeAll(async () => {
    app = await createTestApp({ OTP_DEV_FIXED_CODE: '246810' });
  });

  afterAll(async () => {
    await app.close();
  });

  it('is the code that gets sent and accepted', async () => {
    const phone = nextPhone();
    await app.http.post('/v1/auth/otp/request').send({ phone: phone.e164 }).expect(200);

    expect(app.sms.lastCodeFor(phone.e164)).toBe('246810');
    await app.http
      .post('/v1/auth/otp/verify')
      .send({ phone: phone.e164, code: '246810' })
      .expect(200);
  });
});
