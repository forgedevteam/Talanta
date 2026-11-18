import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { IsOptional, IsString, Matches, MaxLength } from 'class-validator';

import { CursorQueryDto } from '../../../common/pagination/cursor.js';
import { CleanText } from '../../../common/validation/transforms.js';
import { PersonSummaryDto } from '../../profiles/dto/person.dto.js';
import { PortfolioItemDto } from '../../portfolio/dto/portfolio.dto.js';
import { UserTalentDto } from '../../talents/dto/talent.dto.js';

export class CreatorCardDto extends PersonSummaryDto {
  @ApiProperty()
  followerCount: number;

  @ApiProperty()
  portfolioCount: number;
}

export class CreatorPageDto {
  @ApiProperty({ type: () => [CreatorCardDto] })
  items: CreatorCardDto[];

  @ApiProperty({ type: String, nullable: true })
  nextCursor: string | null;
}

export class CreatorProfileDto extends PersonSummaryDto {
  @ApiProperty({ type: String, nullable: true })
  bio: string | null;

  @ApiProperty({ type: () => [UserTalentDto] })
  talents: UserTalentDto[];

  @ApiProperty({ type: () => [PortfolioItemDto] })
  portfolio: PortfolioItemDto[];

  @ApiProperty()
  followerCount: number;

  @ApiProperty()
  followingCount: number;

  @ApiProperty()
  isFollowing: boolean;

  @ApiProperty({ description: 'This is the signed-in person.' })
  isMe: boolean;
}

export class CreatorQueryDto extends CursorQueryDto {
  @ApiPropertyOptional({ description: 'Matches username or display name.' })
  @IsOptional()
  @CleanText()
  @IsString()
  @MaxLength(50)
  q?: string;

  @ApiPropertyOptional({ example: 'music' })
  @IsOptional()
  @Matches(/^[a-z0-9-]{2,40}$/)
  talent?: string;

  @ApiPropertyOptional({ example: 'Douala' })
  @IsOptional()
  @CleanText()
  @IsString()
  @MaxLength(80)
  city?: string;
}

export class FollowingWorkDto extends PortfolioItemDto {
  @ApiProperty({ type: () => PersonSummaryDto })
  creator: PersonSummaryDto;
}

export class FollowingFeedDto {
  @ApiProperty({ type: () => [FollowingWorkDto] })
  items: FollowingWorkDto[];

  @ApiProperty({ type: String, nullable: true })
  nextCursor: string | null;
}

export class FollowStateDto {
  @ApiProperty()
  isFollowing: boolean;

  @ApiProperty()
  followerCount: number;
}
