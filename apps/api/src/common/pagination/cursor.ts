import { ApiPropertyOptional } from '@nestjs/swagger';
import { IsInt, IsOptional, Matches, Max, Min } from 'class-validator';
import { Type } from 'class-transformer';

import { UUID_PATTERN } from '../ids/uuidv7.js';

/**
 * Keyset pagination on UUIDv7 ids. The ids sort by creation time, so "older
 * than this id" is a stable cursor that never skips or repeats rows when new
 * ones arrive, unlike page numbers.
 */
export class CursorQueryDto {
  @ApiPropertyOptional({ description: 'The `nextCursor` from the previous page.' })
  @IsOptional()
  @Matches(UUID_PATTERN, { message: 'Invalid cursor.' })
  cursor?: string;

  @ApiPropertyOptional({ minimum: 1, maximum: 50, default: 20 })
  @IsOptional()
  @Type(() => Number)
  @IsInt()
  @Min(1)
  @Max(50)
  limit?: number;
}

export const DEFAULT_PAGE_SIZE = 20;

export interface Page<T> {
  readonly items: T[];
  readonly nextCursor: string | null;
}

/** Fetch `limit + 1` rows, then call this to split off the extra one. */
export function toPage<T extends { id: string }>(rows: T[], limit: number): Page<T> {
  const items = rows.slice(0, limit);
  const last = items.at(-1);
  return { items, nextCursor: rows.length > limit && last ? last.id : null };
}
