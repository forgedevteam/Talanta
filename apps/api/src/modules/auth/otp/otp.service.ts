import { createHmac, randomInt, timingSafeEqual } from 'node:crypto';

import { HttpStatus, Inject, Injectable, Logger } from '@nestjs/common';

import { AppError } from '../../../common/errors/app-error.js';
import { KEY_VALUE_STORE, type KeyValueStore } from '../../../common/kv/key-value-store.js';
import { RateLimiter } from '../../../common/rate-limit/rate-limiter.js';
import { APP_CONFIG } from '../../../config/config.module.js';
import type { AppConfig } from '../../../config/env.js';
import { SMS_PROVIDER, type SmsProvider } from '../sms/sms-provider.js';

export interface OtpChallenge {
  readonly expiresInSeconds: number;
  readonly resendAfterSeconds: number;
}

const HOUR = 3600;
const CODE_LENGTH = 6;

const codeKey = (phone: string): string => `otp:code:${phone}`;
const attemptsKey = (phone: string): string => `otp:attempts:${phone}`;
const cooldownKey = (phone: string): string => `otp:cooldown:${phone}`;

/**
 * One-time sign-in codes. Only a keyed hash of the code is stored, each code
 * allows a handful of guesses, and requests are limited per phone and per IP.
 */
@Injectable()
export class OtpService {
  private readonly logger = new Logger(OtpService.name);

  constructor(
    @Inject(KEY_VALUE_STORE) private readonly store: KeyValueStore,
    @Inject(SMS_PROVIDER) private readonly sms: SmsProvider,
    @Inject(APP_CONFIG) private readonly config: AppConfig,
    private readonly rateLimiter: RateLimiter,
  ) {}

  /** Sends a fresh code to `phone` (E.164), replacing any earlier one. */
  async request(phone: string, ip: string): Promise<OtpChallenge> {
    const { otp } = this.config;

    const byIp = await this.rateLimiter.consume(`otp:ip:${ip}`, {
      limit: otp.maxPerIpPerHour,
      windowSeconds: HOUR,
    });
    if (!byIp.allowed) throw this.rateLimited(byIp.retryAfterSeconds);

    // Checked before the hourly quota so that an impatient double tap costs nothing.
    const cooldownStarted = await this.store.setIfAbsent(
      cooldownKey(phone),
      '1',
      otp.resendSeconds,
    );
    if (!cooldownStarted) {
      throw new AppError(
        HttpStatus.TOO_MANY_REQUESTS,
        'otp_resend_too_soon',
        'A code was sent a moment ago. Give it time to arrive.',
        { retryAfterSeconds: Math.max(1, await this.store.ttl(cooldownKey(phone))) },
      );
    }

    const byPhone = await this.rateLimiter.consume(`otp:phone:${phone}`, {
      limit: otp.maxPerPhonePerHour,
      windowSeconds: HOUR,
    });
    if (!byPhone.allowed) throw this.rateLimited(byPhone.retryAfterSeconds);

    // Test accounts (store reviewers, QA) get the configured code and no SMS.
    const isTestAccount = otp.testCode !== undefined && otp.testNumbers.has(phone);
    const code = isTestAccount
      ? (otp.testCode ?? '')
      : (otp.devFixedCode ??
        randomInt(0, 10 ** CODE_LENGTH)
          .toString()
          .padStart(CODE_LENGTH, '0'));
    await this.store.set(codeKey(phone), this.hash(phone, code), otp.ttlSeconds);
    await this.store.delete(attemptsKey(phone));

    if (isTestAccount) {
      this.logger.warn(`Sign-in code requested for test account ${phone}; no SMS sent`);
      return { expiresInSeconds: otp.ttlSeconds, resendAfterSeconds: otp.resendSeconds };
    }

    try {
      const minutes = Math.round(otp.ttlSeconds / 60);
      await this.sms.send({
        to: phone,
        body: `${code} is your Talanta code. It expires in ${minutes} minutes. Never share it with anyone.`,
      });
    } catch (error) {
      this.logger.error(
        `SMS provider "${this.sms.name}" failed`,
        error instanceof Error ? error.stack : String(error),
      );
      // Let the person try again straight away: the failure was ours.
      await this.store.delete(codeKey(phone), cooldownKey(phone));
      throw new AppError(
        HttpStatus.BAD_GATEWAY,
        'sms_delivery_failed',
        'The code could not be sent. Try again in a moment.',
      );
    }

    return { expiresInSeconds: otp.ttlSeconds, resendAfterSeconds: otp.resendSeconds };
  }

  /** Resolves when `code` is the live code for `phone`; throws an `AppError` otherwise. */
  async verify(phone: string, code: string, ip: string): Promise<void> {
    // Guessing across many numbers from one place is limited separately from
    // the per-code attempt count.
    const byIp = await this.rateLimiter.consume(`otp:verify-ip:${ip}`, {
      limit: this.config.otp.maxVerifyPerIpPerHour,
      windowSeconds: HOUR,
    });
    if (!byIp.allowed) throw this.rateLimited(byIp.retryAfterSeconds);

    const expected = await this.store.get(codeKey(phone));
    if (expected === null) {
      throw new AppError(
        HttpStatus.BAD_REQUEST,
        'otp_expired',
        'That code has expired. Request a new one.',
      );
    }

    // Count the attempt before comparing so parallel guesses cannot outrun the limit.
    const attempts = await this.store.increment(attemptsKey(phone), this.config.otp.ttlSeconds);
    const matches =
      attempts <= this.config.otp.maxAttempts &&
      timingSafeEqual(Buffer.from(expected, 'hex'), Buffer.from(this.hash(phone, code), 'hex'));

    if (matches) {
      await this.store.delete(codeKey(phone), attemptsKey(phone));
      return;
    }

    if (attempts >= this.config.otp.maxAttempts) {
      await this.store.delete(codeKey(phone), attemptsKey(phone));
      throw new AppError(
        HttpStatus.TOO_MANY_REQUESTS,
        'otp_too_many_attempts',
        'Too many wrong tries. Request a new code.',
      );
    }

    throw new AppError(HttpStatus.BAD_REQUEST, 'otp_invalid', 'That code is not right.');
  }

  private hash(phone: string, code: string): string {
    return createHmac('sha256', this.config.otp.secret).update(`${phone}:${code}`).digest('hex');
  }

  private rateLimited(retryAfterSeconds: number): AppError {
    return new AppError(
      HttpStatus.TOO_MANY_REQUESTS,
      'otp_rate_limited',
      'Too many codes requested. Try again later.',
      { retryAfterSeconds: Math.max(1, retryAfterSeconds) },
    );
  }
}
