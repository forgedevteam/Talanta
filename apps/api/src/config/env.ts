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
    /**
     * Numbers that always accept OTP_TEST_CODE and never receive an SMS, for
     * app-store reviewers and QA. Comma-separated E.164. Use numbers you own.
     */
    OTP_TEST_NUMBERS: z.string().default(''),
    OTP_TEST_CODE: z
      .string()
      .regex(/^\d{6}$/, 'must be 6 digits')
      .optional()
      .or(z.literal('').transform(() => undefined)),
    /** Code guesses allowed from one IP across all numbers, per hour. */
    OTP_MAX_VERIFY_PER_IP_PER_HOUR: z.coerce.number().int().min(1).default(100),
    /** Requests per minute for one signed-in user, and for one IP when signed out. */
    THROTTLE_PER_USER_PER_MINUTE: z.coerce.number().int().min(1).default(240),
    THROTTLE_PER_IP_PER_MINUTE: z.coerce.number().int().min(1).default(120),
    OTP_DEV_FIXED_CODE: z
      .string()
      .regex(/^\d{6}$/, 'must be 6 digits')
      .optional()
      .or(z.literal('').transform(() => undefined)),

    SMS_PROVIDER: z.enum(['console', 'africastalking']).default('console'),
    SMS_ALLOWED_COUNTRIES: z.string().default('CM,NG,KE,GH,ZA'),
    /** `sandbox` sends to the Africa's Talking simulator instead of real phones. */
    AFRICASTALKING_USERNAME: z.string().min(1).optional(),
    AFRICASTALKING_API_KEY: z.string().min(1).optional(),
    /** Registered sender ID or short code. Optional: without one the network default is used. */
    AFRICASTALKING_SENDER_ID: z.string().min(1).optional(),

    /** Younger people cannot create a profile. */
    MIN_SIGNUP_AGE: z.coerce.number().int().min(13).max(21).default(13),

    /** Folder for uploaded photos and videos when they are kept on this server's disk. */
    MEDIA_DIR: z.string().min(1).default('./storage/media'),
    /**
     * Public address files are served from, such as a CDN in front of object
     * storage. Unset: files are served by this API under /media, and clients
     * resolve the relative URL against the API address.
     */
    MEDIA_PUBLIC_BASE_URL: z.url().optional(),
    /** The website, used for links people share. */
    PUBLIC_WEB_URL: z.url().default('https://talanta.app'),

    TRUST_PROXY_HOPS: z.coerce.number().int().min(0).default(0),
    CORS_ORIGINS: z.string().default(''),
  })
  .superRefine((env, ctx) => {
    if (
      env.SMS_PROVIDER === 'africastalking' &&
      (!env.AFRICASTALKING_USERNAME || !env.AFRICASTALKING_API_KEY)
    ) {
      ctx.addIssue({
        code: 'custom',
        path: ['SMS_PROVIDER'],
        message: 'africastalking needs AFRICASTALKING_USERNAME and AFRICASTALKING_API_KEY',
      });
    }
    if (env.OTP_TEST_NUMBERS.trim() && !env.OTP_TEST_CODE) {
      ctx.addIssue({
        code: 'custom',
        path: ['OTP_TEST_CODE'],
        message: 'is required when OTP_TEST_NUMBERS is set',
      });
    }
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
    readonly maxVerifyPerIpPerHour: number;
    readonly testNumbers: ReadonlySet<string>;
    readonly testCode: string | undefined;
  };
  readonly throttle: {
    readonly perUserPerMinute: number;
    readonly perIpPerMinute: number;
  };
  readonly sms: {
    readonly provider: 'console' | 'africastalking';
    /** ISO 3166-1 alpha-2 codes we send codes to. Limits SMS-pumping fraud. */
    readonly allowedCountries: readonly string[];
    readonly africasTalking: {
      readonly username: string;
      readonly apiKey: string;
      readonly senderId: string | undefined;
    } | null;
  };
  readonly safety: {
    readonly minSignupAge: number;
  };
  readonly media: {
    readonly dir: string;
    readonly publicBaseUrl: string | undefined;
  };
  readonly publicWebUrl: string;
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
      maxVerifyPerIpPerHour: env.OTP_MAX_VERIFY_PER_IP_PER_HOUR,
      testNumbers: new Set(csv(env.OTP_TEST_NUMBERS)),
      testCode: env.OTP_TEST_CODE,
    },
    throttle: {
      perUserPerMinute: env.THROTTLE_PER_USER_PER_MINUTE,
      perIpPerMinute: env.THROTTLE_PER_IP_PER_MINUTE,
    },
    sms: {
      provider: env.SMS_PROVIDER,
      allowedCountries: csv(env.SMS_ALLOWED_COUNTRIES).map((code) => code.toUpperCase()),
      africasTalking:
        env.AFRICASTALKING_USERNAME && env.AFRICASTALKING_API_KEY
          ? {
              username: env.AFRICASTALKING_USERNAME,
              apiKey: env.AFRICASTALKING_API_KEY,
              senderId: env.AFRICASTALKING_SENDER_ID,
            }
          : null,
    },
    safety: {
      minSignupAge: env.MIN_SIGNUP_AGE,
    },
    media: {
      dir: env.MEDIA_DIR,
      publicBaseUrl: env.MEDIA_PUBLIC_BASE_URL?.replace(/\/+$/, ''),
    },
    publicWebUrl: env.PUBLIC_WEB_URL.replace(/\/+$/, ''),
  };
}
