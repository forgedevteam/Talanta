/**
 * Stable, machine-readable error codes. Clients switch on these to pick
 * localised copy, so treat every value as part of the public API contract.
 */
export const ERROR_CODES = [
  'validation_failed',
  'unauthorized',
  'forbidden',
  'not_found',
  'conflict',
  'rate_limited',
  'internal_error',
  'service_unavailable',
  'phone_invalid',
  'phone_country_unsupported',
  'otp_resend_too_soon',
  'otp_rate_limited',
  'otp_invalid',
  'otp_expired',
  'otp_too_many_attempts',
  'sms_delivery_failed',
  'session_expired',
  'account_suspended',
  'username_taken',
  'username_reserved',
  'talent_category_unknown',
  'age_below_minimum',
  'adults_only',
  'profile_required',
  'opportunity_closed',
  'already_applied',
  'cannot_apply_to_own',
  'cannot_follow_self',
  'link_not_allowed',
  'limit_reached',
  'media_unsupported',
  'media_too_large',
] as const;

export type ErrorCode = (typeof ERROR_CODES)[number];

export interface AppErrorExtra {
  /** Seconds until the same request can succeed. */
  readonly retryAfterSeconds?: number;
  /** Per-field validation messages, keyed by property name. */
  readonly fields?: Readonly<Record<string, readonly string[]>>;
}

export class AppError extends Error {
  constructor(
    readonly status: number,
    readonly code: ErrorCode,
    message: string,
    readonly extra: AppErrorExtra = {},
  ) {
    super(message);
    this.name = 'AppError';
  }
}
