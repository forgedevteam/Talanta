import {
  Body,
  Controller,
  Get,
  HttpStatus,
  Inject,
  Injectable,
  Module,
  Post,
  Query,
} from '@nestjs/common';
import {
  ApiBearerAuth,
  ApiDefaultResponse,
  ApiOkResponse,
  ApiOperation,
  ApiProperty,
  ApiTags,
} from '@nestjs/swagger';
import { Type } from 'class-transformer';
import { IsDate, IsIn, IsString, Length, Matches } from 'class-validator';
import { and, desc, eq, gt, lte } from 'drizzle-orm';

import { RequireRole } from '../../common/auth/roles.js';
import { CLOCK, type Clock } from '../../common/clock/clock.js';
import { AppError } from '../../common/errors/app-error.js';
import { ProblemDto } from '../../common/errors/problem.dto.js';
import { CleanText } from '../../common/validation/transforms.js';
import { DATABASE, type Database } from '../../database/database.js';
import { promotions, type Promotion } from '../../database/schema/index.js';

export const PROMOTION_PLACEMENTS = ['opportunities_feed'] as const;

/** Either a public https page or an in-app destination such as `talanta:post-call`. */
const PROMOTION_URL = /^(https:\/\/\S{4,490}|talanta:[a-z-]{2,40})$/;

export class PromotionDto {
  @ApiProperty({ format: 'uuid' })
  id: string;

  @ApiProperty({ example: 'Talanta' })
  sponsorName: string;

  @ApiProperty()
  title: string;

  @ApiProperty()
  body: string;

  @ApiProperty({ example: 'Learn more' })
  ctaLabel: string;

  @ApiProperty({ description: 'https:// link, or talanta:<screen> for a screen in the app.' })
  url: string;
}

export class PromotionQueryDto {
  @ApiProperty({ enum: PROMOTION_PLACEMENTS, enumName: 'PromotionPlacement' })
  @IsIn(PROMOTION_PLACEMENTS)
  placement: (typeof PROMOTION_PLACEMENTS)[number];
}

export class CreatePromotionDto extends PromotionQueryDto {
  @ApiProperty()
  @CleanText()
  @IsString()
  @Length(2, 60)
  sponsorName: string;

  @ApiProperty()
  @CleanText()
  @IsString()
  @Length(2, 80)
  title: string;

  @ApiProperty()
  @CleanText()
  @IsString()
  @Length(2, 200)
  body: string;

  @ApiProperty()
  @CleanText()
  @IsString()
  @Length(2, 30)
  ctaLabel: string;

  @ApiProperty({ example: 'https://example.cm/offer' })
  @Matches(PROMOTION_URL, { message: 'Use an https:// link or a talanta: screen.' })
  url: string;

  @ApiProperty()
  @Type(() => Date)
  @IsDate()
  startsAt: Date;

  @ApiProperty()
  @Type(() => Date)
  @IsDate()
  endsAt: Date;
}

const toDto = ({ id, sponsorName, title, body, ctaLabel, url }: Promotion): PromotionDto => ({
  id,
  sponsorName,
  title,
  body,
  ctaLabel,
  url,
});

/** Sponsored cards. The app always labels them as sponsored. */
@Injectable()
export class PromotionsService {
  constructor(
    @Inject(DATABASE) private readonly db: Database,
    @Inject(CLOCK) private readonly clock: Clock,
  ) {}

  async active(placement: Promotion['placement']): Promise<PromotionDto[]> {
    const now = this.clock.now();
    const rows = await this.db
      .select()
      .from(promotions)
      .where(
        and(
          eq(promotions.placement, placement),
          lte(promotions.startsAt, now),
          gt(promotions.endsAt, now),
        ),
      )
      .orderBy(desc(promotions.startsAt))
      .limit(3);
    return rows.map(toDto);
  }

  async create(input: CreatePromotionDto): Promise<PromotionDto> {
    if (input.endsAt <= input.startsAt) {
      throw new AppError(
        HttpStatus.UNPROCESSABLE_ENTITY,
        'validation_failed',
        'The end must come after the start.',
      );
    }
    const [row] = await this.db.insert(promotions).values(input).returning();
    if (!row) throw new Error('Promotion insert returned no row');
    return toDto(row);
  }
}

@ApiTags('promotions')
@ApiBearerAuth()
@ApiDefaultResponse({ type: ProblemDto })
@Controller()
export class PromotionsController {
  constructor(private readonly promotions: PromotionsService) {}

  @Get('promotions')
  @ApiOperation({ summary: 'Sponsored cards running now for a placement' })
  @ApiOkResponse({ type: [PromotionDto] })
  listPromotions(@Query() query: PromotionQueryDto): Promise<PromotionDto[]> {
    return this.promotions.active(query.placement);
  }

  @Post('admin/promotions')
  @RequireRole('admin')
  @ApiOperation({ summary: 'Schedule a sponsored card' })
  @ApiOkResponse({ type: PromotionDto })
  createPromotion(@Body() body: CreatePromotionDto): Promise<PromotionDto> {
    return this.promotions.create(body);
  }
}

@Module({
  controllers: [PromotionsController],
  providers: [PromotionsService],
})
export class PromotionsModule {}
