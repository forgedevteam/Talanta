import { HttpStatus, ValidationPipe, type ValidationError } from '@nestjs/common';

import { AppError } from '../errors/app-error.js';

function collect(
  errors: readonly ValidationError[],
  prefix: string,
  into: Record<string, string[]>,
): void {
  for (const error of errors) {
    const path = prefix ? `${prefix}.${error.property}` : error.property;
    if (error.constraints) into[path] = Object.values(error.constraints);
    if (error.children?.length) collect(error.children, path, into);
  }
}

/**
 * Rejects unknown properties and reports every failure in one response, keyed
 * by field, so a form can mark all its problems after a single round trip.
 */
export function createValidationPipe(): ValidationPipe {
  return new ValidationPipe({
    whitelist: true,
    forbidNonWhitelisted: true,
    transform: true,
    exceptionFactory: (errors) => {
      const fields: Record<string, string[]> = {};
      collect(errors, '', fields);
      return new AppError(
        HttpStatus.UNPROCESSABLE_ENTITY,
        'validation_failed',
        'Some details need another look.',
        { fields },
      );
    },
  });
}
