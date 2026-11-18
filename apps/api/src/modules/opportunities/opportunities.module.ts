import { Module } from '@nestjs/common';

import { AccountModule } from '../account/account.module.js';
import { NotificationsModule } from '../notifications/notifications.module.js';
import { PortfolioModule } from '../portfolio/portfolio.module.js';
import { ProfilesModule } from '../profiles/profiles.module.js';
import { TalentsModule } from '../talents/talents.module.js';
import { OpportunitiesController } from './opportunities.controller.js';
import { OpportunitiesService } from './opportunities.service.js';

@Module({
  imports: [AccountModule, ProfilesModule, TalentsModule, PortfolioModule, NotificationsModule],
  controllers: [OpportunitiesController],
  providers: [OpportunitiesService],
  exports: [OpportunitiesService],
})
export class OpportunitiesModule {}
