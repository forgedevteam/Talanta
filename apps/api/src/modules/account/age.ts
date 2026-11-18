/** Age needed before the protections for minors no longer apply. */
export const ADULT_AGE = 18;

/** Oldest plausible date of birth, to catch typos such as 1900. */
export const MAX_AGE = 120;

const ISO_DATE = /^(\d{4})-(\d{2})-(\d{2})$/;

/** Parses `YYYY-MM-DD` as a calendar date, rejecting impossible days like 2023-02-30. */
export function parseCalendarDate(
  value: string,
): { year: number; month: number; day: number } | null {
  const match = ISO_DATE.exec(value);
  if (!match) return null;
  const [year, month, day] = [Number(match[1]), Number(match[2]), Number(match[3])];
  const date = new Date(Date.UTC(year, month - 1, day));
  if (
    date.getUTCFullYear() !== year ||
    date.getUTCMonth() !== month - 1 ||
    date.getUTCDate() !== day
  ) {
    return null;
  }
  return { year, month, day };
}

/** Whole years between a `YYYY-MM-DD` birth date and `today` (UTC). */
export function ageOn(dateOfBirth: string, today: Date): number {
  const birth = parseCalendarDate(dateOfBirth);
  if (!birth) throw new Error(`Not a calendar date: ${dateOfBirth}`);
  const year = today.getUTCFullYear();
  const month = today.getUTCMonth() + 1;
  const day = today.getUTCDate();
  const hadBirthday = month > birth.month || (month === birth.month && day >= birth.day);
  return year - birth.year - (hadBirthday ? 0 : 1);
}
