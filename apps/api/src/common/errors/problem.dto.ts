import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';

import { ERROR_CODES, type ErrorCode } from './app-error.js';

/** The single error shape returned by every endpoint. */
export class ProblemDto {
  @ApiProperty({ enum: ERROR_CODES, enumName: 'ErrorCode' })
  code: ErrorCode;

  @ApiProperty({ description: 'Developer-facing explanation. Not for display to users.' })
  message: string;

  @ApiPropertyOptional({ description: 'Seconds until the request can be retried.' })
  retryAfterSeconds?: number;

  @ApiPropertyOptional({
    description: 'Validation messages keyed by field name.',
    type: 'object',
    additionalProperties: { type: 'array', items: { type: 'string' } },
  })
  fields?: Record<string, string[]>;
}
