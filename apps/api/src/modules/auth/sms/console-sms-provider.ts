import { Logger } from '@nestjs/common';

import type { SmsMessage, SmsProvider } from './sms-provider.js';

/** Local development only: prints the message instead of sending it. Refused in production by config. */
export class ConsoleSmsProvider implements SmsProvider {
  readonly name = 'console';
  private readonly logger = new Logger('SMS');

  send(message: SmsMessage): Promise<void> {
    this.logger.log(`to ${message.to}: ${message.body}`);
    return Promise.resolve();
  }
}
