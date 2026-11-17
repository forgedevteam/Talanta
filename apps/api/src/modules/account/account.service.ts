import { HttpStatus, Injectable } from '@nestjs/common';

import { AppError } from '../../common/errors/app-error.js';
import { ProfilesService, type Profile, type ProfileInput } from '../profiles/profiles.service.js';
import type { ProfileDto } from '../profiles/dto/profile.dto.js';
import { TalentsService } from '../talents/talents.service.js';
import { UsersService } from '../users/users.service.js';
import type { MeDto, OnboardingStep } from './dto/me.dto.js';

const toProfileDto = (profile: Profile): ProfileDto => ({
  username: profile.username,
  displayName: profile.displayName,
  bio: profile.bio,
  avatarUrl: profile.avatarUrl,
  city: profile.city,
  isVerified: profile.isVerified,
});

/** Composes the signed-in person's view of their own account. */
@Injectable()
export class AccountService {
  constructor(
    private readonly users: UsersService,
    private readonly profiles: ProfilesService,
    private readonly talents: TalentsService,
  ) {}

  async getMe(userId: string): Promise<MeDto> {
    const [user, profile, talents] = await Promise.all([
      this.users.findById(userId),
      this.profiles.findByUserId(userId),
      this.talents.listForUser(userId),
    ]);
    if (!user) {
      throw new AppError(HttpStatus.UNAUTHORIZED, 'unauthorized', 'This account no longer exists.');
    }

    let onboardingStep: OnboardingStep = 'done';
    if (talents.length === 0) onboardingStep = 'talents';
    else if (!profile) onboardingStep = 'profile';

    return {
      id: user.id,
      phone: user.phone,
      country: user.country,
      language: user.language,
      role: user.role,
      profile: profile ? toProfileDto(profile) : null,
      talents: talents.map((talent) => ({ ...talent })),
      onboardingStep,
    };
  }

  async setTalents(
    userId: string,
    categoryIds: readonly string[],
    primaryCategoryId?: string,
  ): Promise<MeDto> {
    await this.talents.replaceForUser(userId, categoryIds, primaryCategoryId);
    return this.getMe(userId);
  }

  async saveProfile(userId: string, input: ProfileInput): Promise<MeDto> {
    await this.profiles.save(userId, input);
    return this.getMe(userId);
  }
}
