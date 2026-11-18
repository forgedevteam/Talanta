import { Module } from '@nestjs/common';

import { SocialService } from './social.service.js';

@Module({
  providers: [SocialService],
  exports: [SocialService],
})
export class SocialModule {}
