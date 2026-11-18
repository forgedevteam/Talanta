import { HttpStatus } from '@nestjs/common';
import { isSupportedCountry, parsePhoneNumberFromString } from 'libphonenumber-js/max';

import { AppError } from '../../../common/errors/app-error.js';

export interface PhoneNumber {
  /** For example +2348031234567. */
  readonly e164: string;
  /** Grouped for reading, for example +237 6 71 23 45 67. */
  readonly international: string;
  /** ISO 3166-1 alpha-2, derived from the number itself. */
  readonly country: string;
}

/** Line types that can never receive a sign-in code and are a favourite of SMS fraud. */
const NOT_A_HANDSET: ReadonlySet<string> = new Set([
  'FIXED_LINE',
  'PREMIUM_RATE',
  'TOLL_FREE',
  'SHARED_COST',
  'UAN',
  'PAGER',
  'VOICEMAIL',
]);

const invalid = (): AppError =>
  new AppError(
    HttpStatus.UNPROCESSABLE_ENTITY,
    'phone_invalid',
    'That phone number does not look right.',
    { fields: { phone: ['Check the number and try again.'] } },
  );

/**
 * Normalises what the person typed ("0803 123 4567" with country NG, or a full
 * international number) to E.164 and checks we send codes to that country.
 */
export function parsePhoneNumber(
  raw: string,
  defaultCountry: string | undefined,
  allowedCountries: readonly string[],
): PhoneNumber {
  const region = defaultCountry && isSupportedCountry(defaultCountry) ? defaultCountry : undefined;
  const parsed = parsePhoneNumberFromString(raw, region);
  if (!parsed?.isValid() || !parsed.country) throw invalid();

  const type = parsed.getType();
  if (type && NOT_A_HANDSET.has(type)) throw invalid();

  if (!allowedCountries.includes(parsed.country)) {
    throw new AppError(
      HttpStatus.UNPROCESSABLE_ENTITY,
      'phone_country_unsupported',
      'Talanta is not available in that country yet.',
    );
  }

  return {
    e164: parsed.number,
    international: parsed.formatInternational(),
    country: parsed.country,
  };
}
