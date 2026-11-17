import { Controller, Get, HttpStatus, Inject, Logger } from '@nestjs/common';
import { ApiOkResponse, ApiOperation, ApiProperty, ApiResponse, ApiTags } from '@nestjs/swagger';
import { sql } from 'drizzle-orm';

import { AppError } from '../../common/errors/app-error.js';
import { ProblemDto } from '../../common/errors/problem.dto.js';
import { KEY_VALUE_STORE, type KeyValueStore } from '../../common/kv/key-value-store.js';
import { DATABASE, type Database } from '../../database/database.js';
import { Public } from '../auth/index.js';

export class HealthDto {
  @ApiProperty({ example: 'ok' })
  status: string;
}

@ApiTags('health')
@Public()
@Controller('health')
export class HealthController {
  private readonly logger = new Logger(HealthController.name);

  constructor(
    @Inject(DATABASE) private readonly db: Database,
    @Inject(KEY_VALUE_STORE) private readonly store: KeyValueStore,
  ) {}

  @Get()
  @ApiOperation({ summary: 'Liveness: the process is up' })
  @ApiOkResponse({ type: HealthDto })
  live(): HealthDto {
    return { status: 'ok' };
  }

  @Get('ready')
  @ApiOperation({ summary: 'Readiness: the database and key-value store answer' })
  @ApiOkResponse({ type: HealthDto })
  @ApiResponse({ status: HttpStatus.SERVICE_UNAVAILABLE, type: ProblemDto })
  async ready(): Promise<HealthDto> {
    try {
      await Promise.all([this.db.execute(sql`select 1`), this.store.ping()]);
    } catch (error) {
      this.logger.error(
        'Readiness check failed',
        error instanceof Error ? error.stack : String(error),
      );
      throw new AppError(
        HttpStatus.SERVICE_UNAVAILABLE,
        'service_unavailable',
        'A dependency is not answering.',
      );
    }
    return { status: 'ok' };
  }
}
