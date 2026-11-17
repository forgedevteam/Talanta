import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import {
  ArrayMaxSize,
  ArrayMinSize,
  ArrayUnique,
  IsArray,
  IsOptional,
  Matches,
} from 'class-validator';

import { UUID_PATTERN } from '../../../common/ids/uuidv7.js';

export const TALENT_LEVELS = ['emerging', 'skilled', 'professional'] as const;
export type TalentLevel = (typeof TALENT_LEVELS)[number];

export const MAX_TALENTS_PER_USER = 5;

export class TalentCategoryDto {
  @ApiProperty({ format: 'uuid' })
  id: string;

  @ApiProperty({ example: 'spoken-word', description: 'Stable key. Safe to switch on.' })
  slug: string;

  @ApiProperty({ example: 'Spoken word' })
  name: string;

  @ApiProperty({ example: 'spoken-word', description: 'Key into the client icon set.' })
  icon: string;
}

export class UserTalentDto {
  @ApiProperty({ format: 'uuid' })
  categoryId: string;

  @ApiProperty({ example: 'music' })
  slug: string;

  @ApiProperty({ example: 'Music' })
  name: string;

  @ApiProperty({ example: 'music' })
  icon: string;

  @ApiProperty({ enum: TALENT_LEVELS, enumName: 'TalentLevel' })
  level: TalentLevel;

  @ApiProperty()
  isPrimary: boolean;
}

export class SetTalentsDto {
  @ApiProperty({
    type: [String],
    format: 'uuid',
    minItems: 1,
    maxItems: MAX_TALENTS_PER_USER,
    description: 'Replaces the full list.',
  })
  @IsArray()
  @ArrayMinSize(1, { message: 'Pick at least one talent.' })
  @ArrayMaxSize(MAX_TALENTS_PER_USER, { message: `Pick up to ${MAX_TALENTS_PER_USER} talents.` })
  @ArrayUnique()
  @Matches(UUID_PATTERN, { each: true, message: 'Each talent must be a category id.' })
  categoryIds: string[];

  @ApiPropertyOptional({
    format: 'uuid',
    description: 'The talent shown first on the profile. Defaults to the first id in the list.',
  })
  @IsOptional()
  @Matches(UUID_PATTERN, { message: 'The main talent must be a category id.' })
  primaryCategoryId?: string;
}
