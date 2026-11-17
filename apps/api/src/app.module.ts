import { Module } from '@nestjs/common';

import { ClockModule } from './common/clock/clock.module.js';
import { KeyValueModule } from './common/kv/key-value.module.js';
import { ConfigModule } from './config/config.module.js';
import { DatabaseModule } from './database/database.module.js';
import { AccountModule } from './modules/account/account.module.js';
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
    HealthModule,
  ],
})
export class AppModule {}
