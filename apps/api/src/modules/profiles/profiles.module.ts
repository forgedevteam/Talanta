import { Module } from '@nestjs/common';

import { TalentsModule } from '../talents/talents.module.js';
import { PeopleService } from './people.service.js';
import { ProfilesController } from './profiles.controller.js';
import { ProfilesService } from './profiles.service.js';

@Module({
  imports: [TalentsModule],
  controllers: [ProfilesController],
  providers: [ProfilesService, PeopleService],
  exports: [ProfilesService, PeopleService],
})
export class ProfilesModule {}
