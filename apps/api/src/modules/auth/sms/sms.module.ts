import { Module } from '@nestjs/common';

import { APP_CONFIG } from '../../../config/config.module.js';
import type { AppConfig } from '../../../config/env.js';
import { ConsoleSmsProvider } from './console-sms-provider.js';
import { SMS_PROVIDER, type SmsProvider } from './sms-provider.js';

@Module({
  providers: [
    {
      provide: SMS_PROVIDER,
      inject: [APP_CONFIG],
      useFactory: (config: AppConfig): SmsProvider => {
        switch (config.sms.provider) {
          case 'console':
            return new ConsoleSmsProvider();
        }
      },
    },
  ],
  exports: [SMS_PROVIDER],
})
export class SmsModule {}
