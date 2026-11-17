import { Module } from '@nestjs/common';

import { ProfilesModule } from '../profiles/profiles.module.js';
import { TalentsModule } from '../talents/talents.module.js';
import { UsersModule } from '../users/users.module.js';
import { AccountService } from './account.service.js';
import { MeController } from './me.controller.js';

@Module({
  imports: [UsersModule, ProfilesModule, TalentsModule],
  controllers: [MeController],
  providers: [AccountService],
  exports: [AccountService],
})
export class AccountModule {}
