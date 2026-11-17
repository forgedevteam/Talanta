import { describe, expect, it } from 'vitest';

import { AppError } from '../../../common/errors/app-error.js';
import { parsePhoneNumber } from './phone-number.js';

const LAUNCH = ['NG', 'KE', 'GH', 'ZA'];

const codeOf = (run: () => unknown): string => {
  try {
    run();
  } catch (error) {
    if (error instanceof AppError) return error.code;
    throw error;
  }
  return 'no error';
};

describe('parsePhoneNumber', () => {
  it.each([
    ['0803 123 4567', 'NG', '+2348031234567'],
    ['803-123-4567', 'NG', '+2348031234567'],
    ['0712 345 678', 'KE', '+254712345678'],
    ['024 123 4567', 'GH', '+233241234567'],
    ['082 123 4567', 'ZA', '+27821234567'],
  ])('reads %s typed in %s as %s', (typed, country, e164) => {
    expect(parsePhoneNumber(typed, country, LAUNCH)).toEqual({ e164, country });
  });

  it('trusts the country in an international number over the picker', () => {
    expect(parsePhoneNumber('+254712345678', 'NG', LAUNCH)).toEqual({
      e164: '+254712345678',
      country: 'KE',
    });
  });

  it('needs a country for a national number', () => {
    expect(codeOf(() => parsePhoneNumber('0803 123 4567', undefined, LAUNCH))).toBe(
      'phone_invalid',
    );
  });

  it('rejects numbers that are too short or made up', () => {
    expect(codeOf(() => parsePhoneNumber('0803', 'NG', LAUNCH))).toBe('phone_invalid');
    expect(codeOf(() => parsePhoneNumber('call me maybe', 'NG', LAUNCH))).toBe('phone_invalid');
  });

  it('rejects landlines, which cannot receive a code', () => {
    expect(codeOf(() => parsePhoneNumber('+27215551234', undefined, LAUNCH))).toBe('phone_invalid');
  });

  it('rejects valid numbers outside the launch countries', () => {
    expect(codeOf(() => parsePhoneNumber('+447400123456', undefined, LAUNCH))).toBe(
      'phone_country_unsupported',
    );
  });
});
