import { Module } from '@nestjs/common';

import { NotificationsService } from './notifications.service.js';

/** A leaf module: it only stores notifications, so anything can depend on it. */
@Module({
  providers: [NotificationsService],
  exports: [NotificationsService],
})
export class NotificationsModule {}
