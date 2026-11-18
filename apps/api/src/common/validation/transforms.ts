import { Transform } from 'class-transformer';

const mapString = (map: (value: string) => string): PropertyDecorator =>
  Transform(({ value }: { value: unknown }): unknown =>
    typeof value === 'string' ? map(value) : value,
  );

/** Trims and collapses inner runs of whitespace to one space. */
export const CleanText = (): PropertyDecorator =>
  mapString((value) => value.trim().replace(/\s+/g, ' '));

/** Tidies text where line breaks matter, keeping at most one blank line in a row. */
export const cleanMultiline = (value: string): string =>
  value
    .replace(/\r\n?/g, '\n')
    .split('\n')
    .map((line) => line.replace(/[ \t\f\v]+/g, ' ').trim())
    .join('\n')
    .replace(/\n{3,}/g, '\n\n')
    .trim();

/** For posts and comments, where people write in paragraphs. */
export const CleanMultiline = (): PropertyDecorator => mapString(cleanMultiline);

export const Lowercase = (): PropertyDecorator => mapString((value) => value.trim().toLowerCase());

export const Uppercase = (): PropertyDecorator => mapString((value) => value.trim().toUpperCase());
