import { Injectable } from '@nestjs/common';

import { TalentsService } from '../talents/talents.service.js';
import type { PersonSummaryDto } from './dto/person.dto.js';
import { ProfilesService } from './profiles.service.js';

/** Builds person cards in two queries, however many people are on screen. */
@Injectable()
export class PeopleService {
  constructor(
    private readonly profiles: ProfilesService,
    private readonly talents: TalentsService,
  ) {}

  /** People without a profile (unfinished or deleted accounts) are left out. */
  async summaries(userIds: readonly string[]): Promise<Map<string, PersonSummaryDto>> {
    const unique = [...new Set(userIds)];
    const [profiles, primary] = await Promise.all([
      this.profiles.findByUserIds(unique),
      this.talents.primaryForUsers(unique),
    ]);
    const result = new Map<string, PersonSummaryDto>();
    for (const [userId, profile] of profiles) {
      result.set(userId, {
        id: userId,
        username: profile.username,
        displayName: profile.displayName,
        city: profile.city,
        avatarUrl: profile.avatarUrl,
        isVerified: profile.isVerified,
        primaryTalent: primary.get(userId) ?? null,
      });
    }
    return result;
  }
}
