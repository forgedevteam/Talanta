import { describe, expect, it } from 'vitest';

import { ageOn, parseCalendarDate } from './age.js';

describe('ageOn', () => {
  const today = new Date('2026-11-18T10:00:00Z');

  it('counts a birthday that has passed this year', () => {
    expect(ageOn('2000-01-15', today)).toBe(26);
  });

  it('does not count a birthday still to come', () => {
    expect(ageOn('2000-12-01', today)).toBe(25);
  });

  it('counts the birthday itself', () => {
    expect(ageOn('2013-11-18', today)).toBe(13);
    expect(ageOn('2013-11-19', today)).toBe(12);
  });

  it('handles a 29 February birthday in a common year', () => {
    expect(ageOn('2008-02-29', new Date('2026-02-28T00:00:00Z'))).toBe(17);
    expect(ageOn('2008-02-29', new Date('2026-03-01T00:00:00Z'))).toBe(18);
  });
});

describe('parseCalendarDate', () => {
  it('accepts real dates and rejects impossible ones', () => {
    expect(parseCalendarDate('2004-02-29')).toEqual({ year: 2004, month: 2, day: 29 });
    expect(parseCalendarDate('2003-02-29')).toBeNull();
    expect(parseCalendarDate('2003-13-01')).toBeNull();
    expect(parseCalendarDate('03/01/2003')).toBeNull();
  });
});
