import { HttpStatus, Inject, Injectable } from '@nestjs/common';

import { CLOCK, type Clock } from '../../common/clock/clock.js';
import { AppError } from '../../common/errors/app-error.js';
import { APP_CONFIG } from '../../config/config.module.js';
import type { AppConfig } from '../../config/env.js';
import { ProfilesService, type Profile, type ProfileInput } from '../profiles/profiles.service.js';
import type { ProfileDto } from '../profiles/dto/profile.dto.js';
import { TalentsService } from '../talents/talents.service.js';
import { UsersService } from '../users/users.service.js';
import { ADULT_AGE, MAX_AGE, ageOn, parseCalendarDate } from './age.js';
import type { MeDto, OnboardingStep } from './dto/me.dto.js';

const toProfileDto = (profile: Profile): ProfileDto => ({
  username: profile.username,
  displayName: profile.displayName,
  bio: profile.bio,
  avatarUrl: profile.avatarUrl,
  city: profile.city,
  isVerified: profile.isVerified,
});

const invalidDateOfBirth = (message: string): AppError =>
  new AppError(HttpStatus.UNPROCESSABLE_ENTITY, 'validation_failed', message, {
    fields: { dateOfBirth: [message] },
  });

/** Composes the signed-in person's view of their own account. */
@Injectable()
export class AccountService {
  constructor(
    private readonly users: UsersService,
    private readonly profiles: ProfilesService,
    private readonly talents: TalentsService,
    @Inject(CLOCK) private readonly clock: Clock,
    @Inject(APP_CONFIG) private readonly config: AppConfig,
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
    else if (!profile || !user.dateOfBirth) onboardingStep = 'profile';

    return {
      id: user.id,
      phone: user.phone,
      country: user.country,
      language: user.language,
      role: user.role,
      dateOfBirth: user.dateOfBirth,
      isMinor: user.dateOfBirth ? ageOn(user.dateOfBirth, this.clock.now()) < ADULT_AGE : null,
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

  /**
   * Saves the profile. The first save must include a date of birth, which is
   * checked against the minimum age and then fixed: changing it later would
   * let a minor step out of the protections that apply to them.
   */
  async saveProfile(
    userId: string,
    input: ProfileInput,
    dateOfBirth: string | undefined,
  ): Promise<MeDto> {
    const user = await this.users.findById(userId);
    if (!user) {
      throw new AppError(HttpStatus.UNAUTHORIZED, 'unauthorized', 'This account no longer exists.');
    }

    const needsDateOfBirth = user.dateOfBirth === null;
    if (needsDateOfBirth) {
      this.checkDateOfBirth(dateOfBirth);
    } else if (dateOfBirth !== undefined && dateOfBirth !== user.dateOfBirth) {
      throw invalidDateOfBirth('Your date of birth is already set. Contact support to change it.');
    }

    await this.profiles.save(userId, input);
    if (needsDateOfBirth && dateOfBirth) await this.users.setDateOfBirth(userId, dateOfBirth);
    return this.getMe(userId);
  }

  private checkDateOfBirth(dateOfBirth: string | undefined): asserts dateOfBirth is string {
    if (dateOfBirth === undefined) throw invalidDateOfBirth('Enter your date of birth.');
    if (!parseCalendarDate(dateOfBirth)) throw invalidDateOfBirth('That date does not exist.');

    const age = ageOn(dateOfBirth, this.clock.now());
    if (age < 0 || age > MAX_AGE) throw invalidDateOfBirth('Check the year and try again.');
    if (age < this.config.safety.minSignupAge) {
      throw new AppError(
        HttpStatus.UNPROCESSABLE_ENTITY,
        'age_below_minimum',
        `People under ${this.config.safety.minSignupAge} cannot use Talanta yet.`,
      );
    }
  }
}
