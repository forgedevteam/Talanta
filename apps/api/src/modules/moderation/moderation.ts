import {
  Body,
  Controller,
  Get,
  HttpCode,
  HttpStatus,
  Inject,
  Injectable,
  Module,
  Param,
  ParseUUIDPipe,
  Post,
} from '@nestjs/common';
import {
  ApiBearerAuth,
  ApiDefaultResponse,
  ApiNoContentResponse,
  ApiOkResponse,
  ApiOperation,
  ApiProperty,
  ApiPropertyOptional,
  ApiTags,
} from '@nestjs/swagger';
import { IsIn, IsOptional, IsString, Matches, MaxLength } from 'class-validator';
import { and, asc, eq } from 'drizzle-orm';

import { RequireRole } from '../../common/auth/roles.js';
import { AppError } from '../../common/errors/app-error.js';
import { ProblemDto } from '../../common/errors/problem.dto.js';
import { UUID_PATTERN } from '../../common/ids/uuidv7.js';
import { RateLimiter } from '../../common/rate-limit/rate-limiter.js';
import { CleanText } from '../../common/validation/transforms.js';
import { DATABASE, isUniqueViolation, type Database } from '../../database/database.js';
import { reports } from '../../database/schema/index.js';
import { CurrentUser, type AuthUser } from '../auth/index.js';
import { AuthModule } from '../auth/auth.module.js';
import { SessionService } from '../auth/sessions/session.service.js';
import {
  FeatureOpportunityDto,
  OpportunityDetailDto,
} from '../opportunities/dto/opportunity.dto.js';
import { OpportunitiesModule } from '../opportunities/opportunities.module.js';
import { OpportunitiesService } from '../opportunities/opportunities.service.js';
import { UsersModule } from '../users/users.module.js';
import { UsersService } from '../users/users.service.js';

export const REPORT_TARGETS = ['user', 'opportunity', 'portfolio_item'] as const;
export const REPORT_REASONS = [
  'scam',
  'harassment',
  'inappropriate',
  'spam',
  'underage',
  'other',
] as const;

export class CreateReportDto {
  @ApiProperty({ enum: REPORT_TARGETS, enumName: 'ReportTarget' })
  @IsIn(REPORT_TARGETS)
  targetType: (typeof REPORT_TARGETS)[number];

  @ApiProperty({
    format: 'uuid',
    description: 'For a user, their username is resolved by the client to the id shown on cards.',
  })
  @Matches(UUID_PATTERN)
  targetId: string;

  @ApiProperty({ enum: REPORT_REASONS, enumName: 'ReportReason' })
  @IsIn(REPORT_REASONS)
  reason: (typeof REPORT_REASONS)[number];

  @ApiPropertyOptional({ maxLength: 500 })
  @IsOptional()
  @CleanText()
  @IsString()
  @MaxLength(500)
  details?: string;
}

export class ReportDto {
  @ApiProperty({ format: 'uuid' })
  id: string;

  @ApiProperty({ enum: REPORT_TARGETS, enumName: 'ReportTarget' })
  targetType: (typeof REPORT_TARGETS)[number];

  @ApiProperty({ format: 'uuid' })
  targetId: string;

  @ApiProperty({ enum: REPORT_REASONS, enumName: 'ReportReason' })
  reason: (typeof REPORT_REASONS)[number];

  @ApiProperty({ type: String, nullable: true })
  details: string | null;

  @ApiProperty()
  createdAt: Date;
}

@Injectable()
export class ModerationService {
  constructor(
    @Inject(DATABASE) private readonly db: Database,
    private readonly rateLimiter: RateLimiter,
  ) {}

  async report(reporterId: string, input: CreateReportDto): Promise<void> {
    const limit = await this.rateLimiter.consume(`report:${reporterId}`, {
      limit: 20,
      windowSeconds: 86_400,
    });
    if (!limit.allowed) {
      throw new AppError(
        HttpStatus.TOO_MANY_REQUESTS,
        'rate_limited',
        'Thanks, we have your reports. Try again tomorrow.',
        {
          retryAfterSeconds: limit.retryAfterSeconds,
        },
      );
    }
    try {
      await this.db.insert(reports).values({
        reporterId,
        targetType: input.targetType,
        targetId: input.targetId,
        reason: input.reason,
        details: input.details ?? null,
      });
    } catch (error) {
      // Reporting twice is fine: the first report already stands.
      if (!isUniqueViolation(error)) throw error;
    }
  }

  async openReports(): Promise<ReportDto[]> {
    const rows = await this.db
      .select()
      .from(reports)
      .where(eq(reports.status, 'open'))
      .orderBy(asc(reports.id))
      .limit(200);
    return rows.map(({ id, targetType, targetId, reason, details, createdAt }) => ({
      id,
      targetType,
      targetId,
      reason,
      details,
      createdAt,
    }));
  }

  async resolve(reportId: string): Promise<void> {
    const updated = await this.db
      .update(reports)
      .set({ status: 'resolved' })
      .where(and(eq(reports.id, reportId), eq(reports.status, 'open')))
      .returning({ id: reports.id });
    if (updated.length === 0)
      throw new AppError(HttpStatus.NOT_FOUND, 'not_found', 'No open report with that id.');
  }
}

@ApiTags('safety')
@ApiBearerAuth()
@ApiDefaultResponse({ type: ProblemDto })
@Controller('reports')
export class ReportsController {
  constructor(private readonly moderation: ModerationService) {}

  @Post()
  @HttpCode(HttpStatus.NO_CONTENT)
  @ApiOperation({ summary: 'Report a person, call or portfolio piece' })
  @ApiNoContentResponse()
  createReport(@CurrentUser() user: AuthUser, @Body() body: CreateReportDto): Promise<void> {
    return this.moderation.report(user.id, body);
  }
}

/** Admin tools. Non-admins get 404, so these routes are not advertised. */
@ApiTags('admin')
@ApiBearerAuth()
@ApiDefaultResponse({ type: ProblemDto })
@RequireRole('admin')
@Controller('admin')
export class AdminController {
  constructor(
    private readonly moderation: ModerationService,
    private readonly opportunities: OpportunitiesService,
    private readonly users: UsersService,
    private readonly sessions: SessionService,
  ) {}

  @Get('reports')
  @ApiOperation({ summary: 'Open reports, oldest first' })
  @ApiOkResponse({ type: [ReportDto] })
  listOpenReports(): Promise<ReportDto[]> {
    return this.moderation.openReports();
  }

  @Post('reports/:id/resolve')
  @HttpCode(HttpStatus.NO_CONTENT)
  @ApiOperation({ summary: 'Close a report' })
  @ApiNoContentResponse()
  resolveReport(@Param('id', new ParseUUIDPipe()) id: string): Promise<void> {
    return this.moderation.resolve(id);
  }

  @Post('opportunities/:id/feature')
  @HttpCode(HttpStatus.OK)
  @ApiOperation({ summary: 'Put a call in the Featured row (paid placement)' })
  @ApiOkResponse({ type: OpportunityDetailDto })
  featureOpportunity(
    @Param('id', new ParseUUIDPipe()) id: string,
    @Body() body: FeatureOpportunityDto,
  ): Promise<OpportunityDetailDto> {
    return this.opportunities.feature(id, body.days);
  }

  @Post('opportunities/:id/remove')
  @HttpCode(HttpStatus.NO_CONTENT)
  @ApiOperation({ summary: 'Take down a call' })
  @ApiNoContentResponse()
  removeOpportunity(@Param('id', new ParseUUIDPipe()) id: string): Promise<void> {
    return this.opportunities.remove(id);
  }

  @Post('users/:id/suspend')
  @HttpCode(HttpStatus.NO_CONTENT)
  @ApiOperation({ summary: 'Suspend an account and sign it out everywhere' })
  @ApiNoContentResponse()
  async suspendUser(
    @CurrentUser() admin: AuthUser,
    @Param('id', new ParseUUIDPipe()) id: string,
  ): Promise<void> {
    if (id === admin.id) {
      throw new AppError(
        HttpStatus.UNPROCESSABLE_ENTITY,
        'validation_failed',
        'You cannot suspend yourself.',
      );
    }
    if (!(await this.users.setStatus(id, 'suspended'))) {
      throw new AppError(HttpStatus.NOT_FOUND, 'not_found', 'No account with that id.');
    }
    await Promise.all([this.sessions.endAllForUser(id), this.opportunities.removeAllForPoster(id)]);
  }
}

@Module({
  imports: [AuthModule, UsersModule, OpportunitiesModule],
  controllers: [ReportsController, AdminController],
  providers: [ModerationService],
})
export class ModerationModule {}
