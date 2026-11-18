import { Module } from '@nestjs/common';

import { NotificationsModule } from '../notifications/notifications.module.js';
import { PortfolioModule } from '../portfolio/portfolio.module.js';
import { PostsModule } from '../posts/posts.module.js';
import { ProfilesModule } from '../profiles/profiles.module.js';
import { SocialModule } from '../social/social.module.js';
import { TalentsModule } from '../talents/talents.module.js';
import { UsersModule } from '../users/users.module.js';
import { CreatorsController } from './creators.controller.js';
import { CreatorsService } from './creators.service.js';

@Module({
  imports: [
    ProfilesModule,
    TalentsModule,
    PortfolioModule,
    SocialModule,
    UsersModule,
    NotificationsModule,
    PostsModule,
  ],
  controllers: [CreatorsController],
  providers: [CreatorsService],
})
export class CreatorsModule {}
