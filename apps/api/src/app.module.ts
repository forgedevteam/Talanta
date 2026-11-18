import { Module } from '@nestjs/common';

import { ClockModule } from './common/clock/clock.module.js';
import { KeyValueModule } from './common/kv/key-value.module.js';
import { ConfigModule } from './config/config.module.js';
import { DatabaseModule } from './database/database.module.js';
import { AccountModule } from './modules/account/account.module.js';
import { ActivityModule } from './modules/activity/activity.js';
import { ClosureModule } from './modules/closure/closure.js';
import { CreatorsModule } from './modules/creators/creators.module.js';
import { ModerationModule } from './modules/moderation/moderation.js';
import { OpportunitiesModule } from './modules/opportunities/opportunities.module.js';
import { MediaModule } from './modules/media/media.module.js';
import { PostsModule } from './modules/posts/posts.module.js';
import { PortfolioModule } from './modules/portfolio/portfolio.module.js';
import { PromotionsModule } from './modules/promotions/promotions.js';
import { AuthModule } from './modules/auth/auth.module.js';
import { HealthModule } from './modules/health/health.module.js';
import { ProfilesModule } from './modules/profiles/profiles.module.js';
import { TalentsModule } from './modules/talents/talents.module.js';
import { UsersModule } from './modules/users/users.module.js';

@Module({
  imports: [
    // Infrastructure, available everywhere.
    ConfigModule,
    ClockModule,
    KeyValueModule,
    DatabaseModule,
    // Features. Each owns its tables and is reached only through its exported services.
    AuthModule,
    UsersModule,
    ProfilesModule,
    TalentsModule,
    AccountModule,
    MediaModule,
    PortfolioModule,
    PostsModule,
    OpportunitiesModule,
    CreatorsModule,
    ActivityModule,
    ModerationModule,
    PromotionsModule,
    ClosureModule,
    HealthModule,
  ],
})
export class AppModule {}
