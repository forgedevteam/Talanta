import { Transform } from 'class-transformer';

const mapString = (map: (value: string) => string): PropertyDecorator =>
  Transform(({ value }: { value: unknown }): unknown =>
    typeof value === 'string' ? map(value) : value,
  );

/** Trims and collapses inner runs of whitespace to one space. */
export const CleanText = (): PropertyDecorator =>
  mapString((value) => value.trim().replace(/\s+/g, ' '));

export const Lowercase = (): PropertyDecorator => mapString((value) => value.trim().toLowerCase());

export const Uppercase = (): PropertyDecorator => mapString((value) => value.trim().toUpperCase());
