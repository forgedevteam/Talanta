import {
  Controller,
  Delete,
  HttpCode,
  HttpStatus,
  Injectable,
  Logger,
  Module,
} from '@nestjs/common';
import {
  ApiBearerAuth,
  ApiDefaultResponse,
  ApiNoContentResponse,
  ApiOperation,
  ApiTags,
} from '@nestjs/swagger';

import { ProblemDto } from '../../common/errors/problem.dto.js';
import { AuthModule } from '../auth/auth.module.js';
import { CurrentUser, type AuthUser } from '../auth/index.js';
import { SessionService } from '../auth/sessions/session.service.js';
import { OpportunitiesModule } from '../opportunities/opportunities.module.js';
import { OpportunitiesService } from '../opportunities/opportunities.service.js';
import { PortfolioModule } from '../portfolio/portfolio.module.js';
import { PortfolioService } from '../portfolio/portfolio.service.js';
import { ProfilesModule } from '../profiles/profiles.module.js';
import { ProfilesService } from '../profiles/profiles.service.js';
import { SocialModule } from '../social/social.module.js';
import { SocialService } from '../social/social.service.js';
import { TalentsModule } from '../talents/talents.module.js';
import { TalentsService } from '../talents/talents.service.js';
import { UsersModule } from '../users/users.module.js';
import { UsersService } from '../users/users.service.js';

/**
 * Deletes an account at the person's request, as app stores and data
 * protection law require. Sessions end first so nothing can act on the
 * account while it is being cleared.
 */
@Injectable()
export class AccountClosureService {
  private readonly logger = new Logger(AccountClosureService.name);

  constructor(
    private readonly sessions: SessionService,
    private readonly users: UsersService,
    private readonly profiles: ProfilesService,
    private readonly talents: TalentsService,
    private readonly portfolio: PortfolioService,
    private readonly social: SocialService,
    private readonly opportunities: OpportunitiesService,
  ) {}

  async close(userId: string): Promise<void> {
    await this.sessions.endAllForUser(userId);
    await this.users.anonymise(userId);
    await Promise.all([
      this.profiles.deleteForUser(userId),
      this.talents.clearForUser(userId),
      this.portfolio.deleteAllForUser(userId),
      this.social.removeAllForUser(userId),
      this.opportunities.removeAllForPoster(userId),
    ]);
    this.logger.log(`Account ${userId} closed at the owner's request`);
  }
}

@ApiTags('me')
@ApiBearerAuth()
@ApiDefaultResponse({ type: ProblemDto })
@Controller('me')
export class AccountClosureController {
  constructor(private readonly closure: AccountClosureService) {}

  @Delete()
  @HttpCode(HttpStatus.NO_CONTENT)
  @ApiOperation({ summary: 'Delete my account and the data that identifies me' })
  @ApiNoContentResponse()
  deleteMyAccount(@CurrentUser() user: AuthUser): Promise<void> {
    return this.closure.close(user.id);
  }
}

@Module({
  imports: [
    AuthModule,
    UsersModule,
    ProfilesModule,
    TalentsModule,
    PortfolioModule,
    SocialModule,
    OpportunitiesModule,
  ],
  controllers: [AccountClosureController],
  providers: [AccountClosureService],
})
export class ClosureModule {}
