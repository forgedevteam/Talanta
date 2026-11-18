import { Module } from '@nestjs/common';

import { APP_CONFIG } from '../../config/config.module.js';
import type { AppConfig } from '../../config/env.js';
import { MediaController } from './media.controller.js';
import { LocalDiskMediaStorage, MEDIA_STORAGE } from './media-storage.js';
import { MediaService } from './media.service.js';

@Module({
  controllers: [MediaController],
  providers: [
    MediaService,
    {
      provide: MEDIA_STORAGE,
      inject: [APP_CONFIG],
      useFactory: (config: AppConfig) =>
        new LocalDiskMediaStorage(config.media.dir, config.media.publicBaseUrl),
    },
  ],
  exports: [MediaService],
})
export class MediaModule {}
