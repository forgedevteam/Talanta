import { ApiProperty } from '@nestjs/swagger';

import { ProfileDto } from '../../profiles/dto/profile.dto.js';
import { UserTalentDto } from '../../talents/dto/talent.dto.js';

export const USER_ROLES = ['member', 'sponsor', 'admin'] as const;
export const ONBOARDING_STEPS = ['talents', 'profile', 'done'] as const;
export type OnboardingStep = (typeof ONBOARDING_STEPS)[number];

/** Everything the app needs to know about the signed-in person, in one response. */
export class MeDto {
  @ApiProperty({ format: 'uuid' })
  id: string;

  @ApiProperty({ type: String, nullable: true, example: '+2348031234567' })
  phone: string | null;

  @ApiProperty({ type: String, nullable: true, example: 'NG' })
  country: string | null;

  @ApiProperty({ example: 'en' })
  language: string;

  @ApiProperty({ enum: USER_ROLES, enumName: 'UserRole' })
  role: (typeof USER_ROLES)[number];

  @ApiProperty({ type: () => ProfileDto, nullable: true })
  profile: ProfileDto | null;

  @ApiProperty({ type: () => [UserTalentDto] })
  talents: UserTalentDto[];

  @ApiProperty({
    enum: ONBOARDING_STEPS,
    enumName: 'OnboardingStep',
    description: 'The next onboarding screen to show, or `done`.',
  })
  onboardingStep: OnboardingStep;
}
