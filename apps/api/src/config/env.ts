import { z } from 'zod';

const csv = (value: string): string[] =>
  value
    .split(',')
    .map((item) => item.trim())
    .filter((item) => item.length > 0);

const secret = z.string().min(32, 'must be at least 32 characters');

const envSchema = z
  .object({
    NODE_ENV: z.enum(['development', 'test', 'production']).default('development'),
    PORT: z.coerce.number().int().min(1).max(65_535).default(3000),

    DATABASE_URL: z.string().min(1),
    REDIS_URL: z.string().min(1).optional(),

    JWT_ACCESS_SECRET: secret,
    JWT_ACCESS_TTL_SECONDS: z.coerce.number().int().min(60).default(900),
    REFRESH_TOKEN_TTL_DAYS: z.coerce.number().int().min(1).default(60),
    REFRESH_REUSE_LEEWAY_SECONDS: z.coerce.number().int().min(0).default(20),

    OTP_SECRET: secret,
    OTP_TTL_SECONDS: z.coerce.number().int().min(60).default(300),
    OTP_RESEND_SECONDS: z.coerce.number().int().min(10).default(60),
    OTP_MAX_ATTEMPTS: z.coerce.number().int().min(1).default(5),
    OTP_MAX_PER_PHONE_PER_HOUR: z.coerce.number().int().min(1).default(5),
    OTP_MAX_PER_IP_PER_HOUR: z.coerce.number().int().min(1).default(30),
    OTP_DEV_FIXED_CODE: z
      .string()
      .regex(/^\d{6}$/, 'must be 6 digits')
      .optional()
      .or(z.literal('').transform(() => undefined)),

    SMS_PROVIDER: z.enum(['console']).default('console'),
    SMS_ALLOWED_COUNTRIES: z.string().default('NG,KE,GH,ZA'),

    TRUST_PROXY_HOPS: z.coerce.number().int().min(0).default(0),
    CORS_ORIGINS: z.string().default(''),
  })
  .superRefine((env, ctx) => {
    if (env.NODE_ENV !== 'production') return;
    if (!env.REDIS_URL) {
      ctx.addIssue({
        code: 'custom',
        path: ['REDIS_URL'],
        message: 'is required in production (the in-memory store is per-process)',
      });
    }
    if (env.OTP_DEV_FIXED_CODE) {
      ctx.addIssue({
        code: 'custom',
        path: ['OTP_DEV_FIXED_CODE'],
        message: 'must not be set in production',
      });
    }
    if (env.SMS_PROVIDER === 'console') {
      ctx.addIssue({
        code: 'custom',
        path: ['SMS_PROVIDER'],
        message: 'the console provider cannot deliver codes in production',
      });
    }
  });

export interface AppConfig {
  readonly environment: 'development' | 'test' | 'production';
  readonly isProduction: boolean;
  readonly port: number;
  readonly databaseUrl: string;
  readonly redisUrl: string | undefined;
  readonly trustProxyHops: number;
  readonly corsOrigins: readonly string[];
  readonly jwt: {
    readonly accessSecret: string;
    readonly accessTtlSeconds: number;
  };
  readonly refresh: {
    readonly ttlDays: number;
    /** A just-rotated token is still accepted for this long, so a retry on a dropped connection does not sign the user out. */
    readonly reuseLeewaySeconds: number;
  };
  readonly otp: {
    readonly secret: string;
    readonly ttlSeconds: number;
    readonly resendSeconds: number;
    readonly maxAttempts: number;
    readonly maxPerPhonePerHour: number;
    readonly maxPerIpPerHour: number;
    readonly devFixedCode: string | undefined;
  };
  readonly sms: {
    readonly provider: 'console';
    /** ISO 3166-1 alpha-2 codes we send codes to. Limits SMS-pumping fraud. */
    readonly allowedCountries: readonly string[];
  };
}

export function loadConfig(source: NodeJS.ProcessEnv = process.env): AppConfig {
  const parsed = envSchema.safeParse(source);
  if (!parsed.success) {
    throw new Error(`Invalid environment configuration:\n${z.prettifyError(parsed.error)}`);
  }
  const env = parsed.data;

  return {
    environment: env.NODE_ENV,
    isProduction: env.NODE_ENV === 'production',
    port: env.PORT,
    databaseUrl: env.DATABASE_URL,
    redisUrl: env.REDIS_URL,
    trustProxyHops: env.TRUST_PROXY_HOPS,
    corsOrigins: csv(env.CORS_ORIGINS),
    jwt: {
      accessSecret: env.JWT_ACCESS_SECRET,
      accessTtlSeconds: env.JWT_ACCESS_TTL_SECONDS,
    },
    refresh: {
      ttlDays: env.REFRESH_TOKEN_TTL_DAYS,
      reuseLeewaySeconds: env.REFRESH_REUSE_LEEWAY_SECONDS,
    },
    otp: {
      secret: env.OTP_SECRET,
      ttlSeconds: env.OTP_TTL_SECONDS,
      resendSeconds: env.OTP_RESEND_SECONDS,
      maxAttempts: env.OTP_MAX_ATTEMPTS,
      maxPerPhonePerHour: env.OTP_MAX_PER_PHONE_PER_HOUR,
      maxPerIpPerHour: env.OTP_MAX_PER_IP_PER_HOUR,
      devFixedCode: env.OTP_DEV_FIXED_CODE,
    },
    sms: {
      provider: env.SMS_PROVIDER,
      allowedCountries: csv(env.SMS_ALLOWED_COUNTRIES).map((code) => code.toUpperCase()),
    },
  };
}
