import {
  type ArgumentsHost,
  Catch,
  type ExceptionFilter,
  HttpException,
  HttpStatus,
  Logger,
} from '@nestjs/common';
import type { Response } from 'express';

import { AppError, type ErrorCode } from './app-error.js';

interface ProblemBody {
  code: ErrorCode;
  message: string;
  retryAfterSeconds?: number;
  fields?: Readonly<Record<string, readonly string[]>>;
}

const STATUS_CODES: Readonly<Record<number, ErrorCode>> = {
  [HttpStatus.UNAUTHORIZED]: 'unauthorized',
  [HttpStatus.FORBIDDEN]: 'forbidden',
  [HttpStatus.NOT_FOUND]: 'not_found',
  [HttpStatus.CONFLICT]: 'conflict',
  // Raised by the upload parser before our code sees the file.
  [HttpStatus.PAYLOAD_TOO_LARGE]: 'media_too_large',
  [HttpStatus.TOO_MANY_REQUESTS]: 'rate_limited',
};

/** Turns every thrown error into the `ProblemDto` shape. */
@Catch()
export class ProblemFilter implements ExceptionFilter {
  private readonly logger = new Logger(ProblemFilter.name);

  catch(exception: unknown, host: ArgumentsHost): void {
    const response = host.switchToHttp().getResponse<Response>();
    const { status, body } = this.toProblem(exception);

    if (body.retryAfterSeconds !== undefined) {
      response.setHeader('Retry-After', String(body.retryAfterSeconds));
    }
    response.status(status).json(body);
  }

  private toProblem(exception: unknown): { status: number; body: ProblemBody } {
    if (exception instanceof AppError) {
      return {
        status: exception.status,
        body: { code: exception.code, message: exception.message, ...exception.extra },
      };
    }

    if (exception instanceof HttpException) {
      const status = exception.getStatus();
      if (status < 500) {
        return {
          status,
          body: { code: STATUS_CODES[status] ?? 'validation_failed', message: exception.message },
        };
      }
    }

    this.logger.error(
      exception instanceof Error ? (exception.stack ?? exception.message) : String(exception),
    );
    return {
      status: HttpStatus.INTERNAL_SERVER_ERROR,
      body: { code: 'internal_error', message: 'Something went wrong on our side.' },
    };
  }
}
