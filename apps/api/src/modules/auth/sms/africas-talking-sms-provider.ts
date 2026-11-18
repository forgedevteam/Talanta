import type { SmsMessage, SmsProvider } from './sms-provider.js';

export interface AfricasTalkingOptions {
  readonly username: string;
  readonly apiKey: string;
  readonly senderId: string | undefined;
  /** Injected in tests. */
  readonly fetch?: typeof fetch;
  readonly timeoutMs?: number;
}

interface Recipient {
  readonly statusCode?: number;
  readonly status?: string;
  readonly number?: string;
}

interface MessagingResponse {
  readonly SMSMessageData?: {
    readonly Message?: string;
    readonly Recipients?: readonly Recipient[];
  };
}

/** Recipient status codes that mean the message was accepted for delivery. */
const ACCEPTED = new Set([100, 101, 102]);

/**
 * Sends through Africa's Talking (https://africastalking.com), which covers
 * all four launch countries. The `sandbox` username routes to their simulator.
 */
export class AfricasTalkingSmsProvider implements SmsProvider {
  readonly name = 'africastalking';
  private readonly endpoint: string;
  private readonly fetch: typeof fetch;
  private readonly timeoutMs: number;

  constructor(private readonly options: AfricasTalkingOptions) {
    this.endpoint =
      options.username === 'sandbox'
        ? 'https://api.sandbox.africastalking.com/version1/messaging'
        : 'https://api.africastalking.com/version1/messaging';
    this.fetch = options.fetch ?? fetch;
    this.timeoutMs = options.timeoutMs ?? 10_000;
  }

  async send(message: SmsMessage): Promise<void> {
    const form = new URLSearchParams({
      username: this.options.username,
      to: message.to,
      message: message.body,
    });
    if (this.options.senderId) form.set('from', this.options.senderId);

    const response = await this.fetch(this.endpoint, {
      method: 'POST',
      headers: {
        apiKey: this.options.apiKey,
        Accept: 'application/json',
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: form.toString(),
      signal: AbortSignal.timeout(this.timeoutMs),
    });

    if (!response.ok) {
      throw new Error(`Africa's Talking answered HTTP ${response.status}`);
    }

    const payload = (await response.json()) as MessagingResponse;
    const recipient = payload.SMSMessageData?.Recipients?.[0];
    if (recipient?.statusCode === undefined || !ACCEPTED.has(recipient.statusCode)) {
      const reason = recipient?.status ?? payload.SMSMessageData?.Message ?? 'no recipient';
      throw new Error(`Africa's Talking rejected the message: ${reason}`);
    }
  }
}
