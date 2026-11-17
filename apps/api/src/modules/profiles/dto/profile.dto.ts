import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { IsOptional, IsString, Length, Matches, MaxLength } from 'class-validator';

import { CleanText, Lowercase } from '../../../common/validation/transforms.js';
import { USERNAME_PATTERN } from '../username.js';

const USERNAME_RULE = 'Use 3 to 24 letters, numbers or underscores.';

export class ProfileDto {
  @ApiProperty({ example: 'amara_sings' })
  username: string;

  @ApiProperty({ example: 'Amara Okafor' })
  displayName: string;

  @ApiProperty({ type: String, nullable: true })
  bio: string | null;

  @ApiProperty({ type: String, nullable: true })
  avatarUrl: string | null;

  @ApiProperty({ type: String, nullable: true, example: 'Lagos' })
  city: string | null;

  @ApiProperty()
  isVerified: boolean;
}

export class UpdateProfileDto {
  @ApiProperty({ example: 'Amara Okafor', minLength: 2, maxLength: 50 })
  @CleanText()
  @IsString()
  @Length(2, 50, { message: 'Your name should be 2 to 50 characters.' })
  displayName: string;

  @ApiProperty({ example: 'amara_sings', pattern: USERNAME_PATTERN.source })
  @Lowercase()
  @IsString()
  @Matches(USERNAME_PATTERN, { message: USERNAME_RULE })
  username: string;

  @ApiProperty({ example: 'Lagos', minLength: 2, maxLength: 80 })
  @CleanText()
  @IsString()
  @Length(2, 80, { message: 'Tell us the city you create from.' })
  city: string;

  @ApiPropertyOptional({ maxLength: 280 })
  @IsOptional()
  @CleanText()
  @IsString()
  @MaxLength(280, { message: 'Keep your bio under 280 characters.' })
  bio?: string;
}

export class UsernameQueryDto {
  @ApiProperty({ example: 'amara_sings', pattern: USERNAME_PATTERN.source })
  @Lowercase()
  @IsString()
  @Matches(USERNAME_PATTERN, { message: USERNAME_RULE })
  username: string;
}

export const USERNAME_STATUSES = ['available', 'taken', 'reserved'] as const;
export type UsernameStatus = (typeof USERNAME_STATUSES)[number];

export class UsernameAvailabilityDto {
  @ApiProperty({ example: 'amara_sings' })
  username: string;

  @ApiProperty({ enum: USERNAME_STATUSES, enumName: 'UsernameStatus' })
  status: UsernameStatus;
}
