import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { IsOptional, IsString, Length, Matches, MaxLength } from 'class-validator';

import { UUID_PATTERN } from '../../../common/ids/uuidv7.js';
import { CleanText } from '../../../common/validation/transforms.js';

export const PORTFOLIO_PLATFORMS = [
  'youtube',
  'tiktok',
  'instagram',
  'facebook',
  'audiomack',
  'boomplay',
  'soundcloud',
  'spotify',
  'other',
] as const;

export class PortfolioItemDto {
  @ApiProperty({ format: 'uuid' })
  id: string;

  @ApiProperty({ example: 'Live at Institut Français, Douala' })
  title: string;

  @ApiProperty({ type: String, nullable: true })
  description: string | null;

  @ApiProperty({ example: 'https://www.youtube.com/watch?v=abc123' })
  url: string;

  @ApiProperty({ enum: PORTFOLIO_PLATFORMS, enumName: 'PortfolioPlatform' })
  platform: (typeof PORTFOLIO_PLATFORMS)[number];

  @ApiProperty({ type: String, nullable: true, example: 'music' })
  categorySlug: string | null;

  @ApiProperty()
  createdAt: Date;
}

export class CreatePortfolioItemDto {
  @ApiProperty({ example: 'Live at Institut Français, Douala', minLength: 2, maxLength: 80 })
  @CleanText()
  @IsString()
  @Length(2, 80, { message: 'Give it a title of 2 to 80 characters.' })
  title: string;

  @ApiProperty({ example: 'https://www.youtube.com/watch?v=abc123', maxLength: 500 })
  @IsString()
  @Length(10, 500, { message: 'Paste a full link, starting with https://' })
  url: string;

  @ApiPropertyOptional({ maxLength: 500 })
  @IsOptional()
  @CleanText()
  @IsString()
  @MaxLength(500)
  description?: string;

  @ApiPropertyOptional({ format: 'uuid', description: 'The talent this work shows.' })
  @IsOptional()
  @Matches(UUID_PATTERN, { message: 'Choose a talent from the list.' })
  categoryId?: string;
}
