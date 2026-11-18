import { ApiProperty } from '@nestjs/swagger';

import { TalentCategoryDto } from '../../talents/dto/talent.dto.js';

/** How a person appears on cards: in lists, on calls and as an applicant. */
export class PersonSummaryDto {
  @ApiProperty({ format: 'uuid' })
  id: string;

  @ApiProperty({ example: 'nkeng_sings' })
  username: string;

  @ApiProperty({ example: 'Nkeng Ebai' })
  displayName: string;

  @ApiProperty({ type: String, nullable: true, example: 'Douala' })
  city: string | null;

  @ApiProperty({
    type: String,
    nullable: true,
    description: 'Absolute, or relative to the API origin.',
  })
  avatarUrl: string | null;

  @ApiProperty()
  isVerified: boolean;

  @ApiProperty({ type: () => TalentCategoryDto, nullable: true })
  primaryTalent: TalentCategoryDto | null;
}
