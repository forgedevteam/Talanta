export const CLOCK = Symbol('CLOCK');

/** Time source. Injected so expiry and rate-limit rules can be tested without waiting. */
export interface Clock {
  now(): Date;
}

export const systemClock: Clock = {
  now: () => new Date(),
};
