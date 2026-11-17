export const SMS_PROVIDER = Symbol('SMS_PROVIDER');

export interface SmsMessage {
  /** E.164 destination. */
  readonly to: string;
  readonly body: string;
}

/**
 * The one thing auth needs from an SMS gateway. Add a provider (Africa's
 * Talking, Termii, Twilio...) by implementing this and wiring it in `SmsModule`.
 */
export interface SmsProvider {
  readonly name: string;
  /** Resolves once the gateway has accepted the message; rejects otherwise. */
  send(message: SmsMessage): Promise<void>;
}
