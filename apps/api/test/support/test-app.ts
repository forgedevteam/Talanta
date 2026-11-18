import 'reflect-metadata';

import { mkdtemp, rm } from 'node:fs/promises';
import { tmpdir } from 'node:os';
import { join } from 'node:path';

import { PGlite } from '@electric-sql/pglite';
import type { NestExpressApplication } from '@nestjs/platform-express';
import { Test } from '@nestjs/testing';
import { drizzle } from 'drizzle-orm/pglite';
import { migrate } from 'drizzle-orm/pglite/migrator';
import request from 'supertest';
import type TestAgent from 'supertest/lib/agent.js';

import { AppModule } from '../../src/app.module.js';
import { configureApp } from '../../src/app.setup.js';
import { CLOCK, type Clock } from '../../src/common/clock/clock.js';
import { APP_CONFIG } from '../../src/config/config.module.js';
import { loadConfig } from '../../src/config/env.js';
import { DATABASE, type Database } from '../../src/database/database.js';
import { PG_POOL } from '../../src/database/database.module.js';
import { MIGRATIONS_FOLDER } from '../../src/database/migrations.js';
import * as schema from '../../src/database/schema/index.js';
import { seedTalentCategories } from '../../src/database/seed-data.js';
import {
  SMS_PROVIDER,
  type SmsMessage,
  type SmsProvider,
} from '../../src/modules/auth/sms/sms-provider.js';

/** A clock the test moves by hand. */
export class TestClock implements Clock {
  private current = new Date('2026-11-15T09:00:00.000Z');

  now(): Date {
    return new Date(this.current);
  }

  advance(seconds: number): void {
    this.current = new Date(this.current.getTime() + seconds * 1000);
  }
}

/** Collects messages instead of sending them. */
export class FakeSmsProvider implements SmsProvider {
  readonly name = 'fake';
  readonly sent: SmsMessage[] = [];
  failNext = false;

  send(message: SmsMessage): Promise<void> {
    if (this.failNext) {
      this.failNext = false;
      return Promise.reject(new Error('gateway unavailable'));
    }
    this.sent.push(message);
    return Promise.resolve();
  }

  /** The code in the most recent message to `phone`. */
  lastCodeFor(phone: string): string {
    const message = this.sent.findLast((candidate) => candidate.to === phone);
    const code = message?.body.match(/\d{6}/)?.[0];
    if (!code) throw new Error(`No code was sent to ${phone}`);
    return code;
  }
}

export interface TestApp {
  readonly http: TestAgent;
  readonly clock: TestClock;
  readonly sms: FakeSmsProvider;
  readonly db: Database;
  close(): Promise<void>;
}

const BASE_ENV: Record<string, string> = {
  NODE_ENV: 'test',
  DATABASE_URL: 'postgres://unused-in-tests/talanta',
  JWT_ACCESS_SECRET: 'test-access-secret-test-access-secret-0123',
  OTP_SECRET: 'test-otp-secret-test-otp-secret-0123456789',
  // High enough that one test file never trips it by accident.
  OTP_MAX_PER_IP_PER_HOUR: '1000',
};

/**
 * The real application over an in-process Postgres, with the clock and the
 * SMS gateway under the test's control. One per test file.
 */
export async function createTestApp(env: Record<string, string> = {}): Promise<TestApp> {
  const client = new PGlite();
  const pglite = drizzle(client, { schema });
  await migrate(pglite, { migrationsFolder: MIGRATIONS_FOLDER });
  const db: Database = pglite;
  await seedTalentCategories(db);

  const mediaDir = await mkdtemp(join(tmpdir(), 'talanta-media-'));
  const config = loadConfig({ ...BASE_ENV, MEDIA_DIR: mediaDir, ...env });
  const clock = new TestClock();
  const sms = new FakeSmsProvider();

  const moduleRef = await Test.createTestingModule({ imports: [AppModule] })
    .overrideProvider(APP_CONFIG)
    .useValue(config)
    .overrideProvider(PG_POOL)
    .useValue({ end: () => Promise.resolve() })
    .overrideProvider(DATABASE)
    .useValue(db)
    .overrideProvider(CLOCK)
    .useValue(clock)
    .overrideProvider(SMS_PROVIDER)
    .useValue(sms)
    .compile();

  const app = moduleRef.createNestApplication<NestExpressApplication>({ logger: false });
  configureApp(app, config);
  await app.init();

  return {
    http: request(app.getHttpServer()),
    clock,
    sms,
    db,
    close: async () => {
      await app.close();
      await client.close();
      await rm(mediaDir, { recursive: true, force: true });
    },
  };
}

let phoneCounter = 0;

/** A fresh, valid Nigerian mobile number in national format, and its E.164 form. */
export function nextPhone(): { national: string; e164: string } {
  phoneCounter += 1;
  const subscriber = String(1_000_000 + phoneCounter);
  return { national: `0803${subscriber}`, e164: `+234803${subscriber}` };
}

export interface SignedIn {
  readonly phone: string;
  readonly accessToken: string;
  readonly refreshToken: string;
  readonly userId: string;
}

/** Runs the whole OTP flow for a new number. */
export async function signIn(app: TestApp, phone = nextPhone()): Promise<SignedIn> {
  await app.http
    .post('/v1/auth/otp/request')
    .send({ phone: phone.national, country: 'NG' })
    .expect(200);
  const response = await app.http
    .post('/v1/auth/otp/verify')
    .send({ phone: phone.e164, code: app.sms.lastCodeFor(phone.e164) })
    .expect(200);
  const body = response.body as {
    tokens: { accessToken: string; refreshToken: string };
    me: { id: string };
  };
  return {
    phone: phone.e164,
    accessToken: body.tokens.accessToken,
    refreshToken: body.tokens.refreshToken,
    userId: body.me.id,
  };
}

export const bearer = (session: SignedIn): [string, string] => [
  'Authorization',
  `Bearer ${session.accessToken}`,
];

let usernameCounter = 0;

export interface Member extends SignedIn {
  readonly username: string;
}

/** Signs in a new number and completes onboarding. Adults unless told otherwise. */
export async function onboard(
  app: TestApp,
  options: { dateOfBirth?: string; talent?: string; city?: string } = {},
): Promise<Member> {
  const session = await signIn(app);
  const categories = (await app.http.get('/v1/talent-categories').expect(200)).body as {
    id: string;
    slug: string;
  }[];
  const category = categories.find((c) => c.slug === (options.talent ?? 'music')) ?? categories[0];
  await app.http
    .put('/v1/me/talents')
    .set(...bearer(session))
    .send({ categoryIds: [category?.id] })
    .expect(200);
  usernameCounter += 1;
  const username = `member_${usernameCounter}`;
  await app.http
    .put('/v1/me/profile')
    .set(...bearer(session))
    .send({
      displayName: `Member ${usernameCounter}`,
      username,
      city: options.city ?? 'Douala',
      dateOfBirth: options.dateOfBirth ?? '1995-04-12',
    })
    .expect(200);
  return { ...session, username };
}

export async function categoryId(app: TestApp, slug: string): Promise<string> {
  const categories = (await app.http.get('/v1/talent-categories').expect(200)).body as {
    id: string;
    slug: string;
  }[];
  const found = categories.find((c) => c.slug === slug);
  if (!found) throw new Error(`No category ${slug}`);
  return found.id;
}
