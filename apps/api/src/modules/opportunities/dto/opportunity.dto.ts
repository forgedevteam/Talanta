import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { Type } from 'class-transformer';
import {
  IsIn,
  IsInt,
  IsOptional,
  IsString,
  Length,
  Matches,
  Max,
  MaxLength,
  Min,
  ValidateIf,
} from 'class-validator';

import { UUID_PATTERN } from '../../../common/ids/uuidv7.js';
import { CursorQueryDto } from '../../../common/pagination/cursor.js';
import { CleanText } from '../../../common/validation/transforms.js';
import { PersonSummaryDto } from '../../profiles/dto/person.dto.js';
import { PortfolioItemDto } from '../../portfolio/dto/portfolio.dto.js';
import { TalentCategoryDto } from '../../talents/dto/talent.dto.js';

export const COMPENSATION_TYPES = ['paid', 'unpaid', 'negotiable'] as const;
export const OPPORTUNITY_STATUSES = ['open', 'closed', 'removed'] as const;
export const APPLICATION_STATUSES = ['submitted', 'shortlisted', 'declined', 'hired'] as const;
export const DECISIONS = ['shortlisted', 'declined', 'hired'] as const;

export type CompensationType = (typeof COMPENSATION_TYPES)[number];
export type ApplicationStatus = (typeof APPLICATION_STATUSES)[number];

const DATE_PATTERN = /^\d{4}-\d{2}-\d{2}$/;

export class OpportunitySummaryDto {
  @ApiProperty({ format: 'uuid' })
  id: string;

  @ApiProperty({ example: 'Singer for a wedding reception in Douala' })
  title: string;

  @ApiProperty({ type: () => TalentCategoryDto })
  category: TalentCategoryDto;

  @ApiProperty({ example: 'Douala' })
  city: string;

  @ApiProperty({ example: 'CM' })
  country: string;

  @ApiProperty({ enum: COMPENSATION_TYPES, enumName: 'CompensationType' })
  compensation: CompensationType;

  @ApiProperty({ type: Number, nullable: true, example: 150000 })
  budgetAmount: number | null;

  @ApiProperty({ example: 'XAF' })
  currency: string;

  @ApiProperty({ type: String, nullable: true, example: '2026-12-20', description: 'YYYY-MM-DD.' })
  deadline: string | null;

  @ApiProperty({ enum: OPPORTUNITY_STATUSES, enumName: 'OpportunityStatus' })
  status: (typeof OPPORTUNITY_STATUSES)[number];

  @ApiProperty({ description: 'Paid placement. Show with a Featured label.' })
  isFeatured: boolean;

  @ApiProperty()
  applicationsCount: number;

  @ApiProperty({ type: () => PersonSummaryDto, nullable: true })
  poster: PersonSummaryDto | null;

  @ApiProperty()
  createdAt: Date;
}

export class MyApplicationRefDto {
  @ApiProperty({ format: 'uuid' })
  id: string;

  @ApiProperty({ enum: APPLICATION_STATUSES, enumName: 'ApplicationStatus' })
  status: ApplicationStatus;
}

export class OpportunityDetailDto extends OpportunitySummaryDto {
  @ApiProperty()
  description: string;

  @ApiProperty({ description: 'The signed-in person posted this.' })
  isMine: boolean;

  @ApiProperty({ type: () => MyApplicationRefDto, nullable: true })
  myApplication: MyApplicationRefDto | null;
}

export class OpportunityFeedDto {
  @ApiProperty({
    type: () => [OpportunitySummaryDto],
    description: 'Paid placements, only on the first page.',
  })
  featured: OpportunitySummaryDto[];

  @ApiProperty({ type: () => [OpportunitySummaryDto] })
  items: OpportunitySummaryDto[];

  @ApiProperty({ type: String, nullable: true })
  nextCursor: string | null;
}

export class OpportunityQueryDto extends CursorQueryDto {
  @ApiPropertyOptional({ example: 'music', description: 'Talent category slug.' })
  @IsOptional()
  @Matches(/^[a-z0-9-]{2,40}$/)
  category?: string;

  @ApiPropertyOptional({ example: 'Douala' })
  @IsOptional()
  @CleanText()
  @IsString()
  @MaxLength(80)
  city?: string;
}

export class CreateOpportunityDto {
  @ApiProperty({
    example: 'Singer for a wedding reception in Douala',
    minLength: 5,
    maxLength: 100,
  })
  @CleanText()
  @IsString()
  @Length(5, 100, { message: 'Give your call a title of 5 to 100 characters.' })
  title: string;

  @ApiProperty({ minLength: 20, maxLength: 2000 })
  @IsString()
  @Length(20, 2000, { message: 'Describe the work in 20 to 2000 characters.' })
  description: string;

  @ApiProperty({ format: 'uuid' })
  @Matches(UUID_PATTERN, { message: 'Choose the talent you are looking for.' })
  categoryId: string;

  @ApiProperty({ example: 'Douala' })
  @CleanText()
  @IsString()
  @Length(2, 80, { message: 'Say which city the work is in.' })
  city: string;

  @ApiProperty({ enum: COMPENSATION_TYPES, enumName: 'CompensationType' })
  @IsIn(COMPENSATION_TYPES)
  compensation: CompensationType;

  @ApiPropertyOptional({
    example: 150000,
    description: 'Required when the work is paid, so talent knows what to expect.',
  })
  @ValidateIf(
    (dto: CreateOpportunityDto) => dto.compensation === 'paid' || dto.budgetAmount !== undefined,
  )
  @Type(() => Number)
  @IsInt({ message: 'Enter the amount as a whole number.' })
  @Min(500, { message: 'Enter the amount you will pay.' })
  @Max(100_000_000)
  budgetAmount?: number;

  @ApiPropertyOptional({ example: '2026-12-20', pattern: DATE_PATTERN.source })
  @IsOptional()
  @Matches(DATE_PATTERN, { message: 'Choose a closing date.' })
  deadline?: string;
}

export class ApplyDto {
  @ApiProperty({ minLength: 10, maxLength: 1000 })
  @IsString()
  @Length(10, 1000, { message: 'Tell them why you are right for it, in 10 to 1000 characters.' })
  message: string;

  @ApiPropertyOptional({ format: 'uuid', description: 'A piece from your portfolio to show.' })
  @IsOptional()
  @Matches(UUID_PATTERN)
  portfolioItemId?: string;
}

export class ApplicantDto {
  @ApiProperty({ format: 'uuid' })
  applicationId: string;

  @ApiProperty({ enum: APPLICATION_STATUSES, enumName: 'ApplicationStatus' })
  status: ApplicationStatus;

  @ApiProperty()
  message: string;

  @ApiProperty()
  createdAt: Date;

  @ApiProperty({ type: () => PersonSummaryDto })
  applicant: PersonSummaryDto;

  @ApiProperty({ type: () => PortfolioItemDto, nullable: true })
  portfolioItem: PortfolioItemDto | null;
}

export class DecideApplicationDto {
  @ApiProperty({ enum: DECISIONS, enumName: 'ApplicationDecision' })
  @IsIn(DECISIONS)
  status: (typeof DECISIONS)[number];
}

export class MyApplicationDto {
  @ApiProperty({ format: 'uuid' })
  applicationId: string;

  @ApiProperty({ enum: APPLICATION_STATUSES, enumName: 'ApplicationStatus' })
  status: ApplicationStatus;

  @ApiProperty()
  createdAt: Date;

  @ApiProperty({ type: () => OpportunitySummaryDto })
  opportunity: OpportunitySummaryDto;
}

export class FeatureOpportunityDto {
  @ApiProperty({ minimum: 1, maximum: 60, description: 'Days to show in the Featured row.' })
  @Type(() => Number)
  @IsInt()
  @Min(1)
  @Max(60)
  days: number;
}
