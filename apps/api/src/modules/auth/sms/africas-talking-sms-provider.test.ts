import { describe, expect, it } from 'vitest';

import { AfricasTalkingSmsProvider } from './africas-talking-sms-provider.js';

interface Captured {
  url: string;
  init: RequestInit;
}

function fakeFetch(status: number, body: unknown): { fetch: typeof fetch; calls: Captured[] } {
  const calls: Captured[] = [];
  const fn: typeof fetch = (input, init) => {
    const url = input instanceof Request ? input.url : input.toString();
    calls.push({ url, init: init ?? {} });
    return Promise.resolve(
      new Response(JSON.stringify(body), {
        status,
        headers: { 'Content-Type': 'application/json' },
      }),
    );
  };
  return { fetch: fn, calls };
}

const accepted = {
  SMSMessageData: {
    Message: 'Sent to 1/1 Total Cost: NGN 2.20',
    Recipients: [{ statusCode: 101, number: '+2348031234567', status: 'Success' }],
  },
};

describe('AfricasTalkingSmsProvider', () => {
  it('posts the message as a form with the API key header', async () => {
    const { fetch, calls } = fakeFetch(201, accepted);
    const provider = new AfricasTalkingSmsProvider({
      username: 'talanta',
      apiKey: 'key-123',
      senderId: 'TALANTA',
      fetch,
    });

    await provider.send({ to: '+2348031234567', body: '482913 is your Talanta code.' });

    const [call] = calls;
    expect(call?.url).toBe('https://api.africastalking.com/version1/messaging');
    expect(call?.init.method).toBe('POST');
    expect((call?.init.headers as Record<string, string>).apiKey).toBe('key-123');
    const form = new URLSearchParams(call?.init.body as string);
    expect(Object.fromEntries(form)).toEqual({
      username: 'talanta',
      to: '+2348031234567',
      message: '482913 is your Talanta code.',
      from: 'TALANTA',
    });
  });

  it('uses the simulator for the sandbox account and omits an unset sender', async () => {
    const { fetch, calls } = fakeFetch(201, accepted);
    const provider = new AfricasTalkingSmsProvider({
      username: 'sandbox',
      apiKey: 'k',
      senderId: undefined,
      fetch,
    });

    await provider.send({ to: '+254712345678', body: 'hi' });

    expect(calls[0]?.url).toBe('https://api.sandbox.africastalking.com/version1/messaging');
    expect(new URLSearchParams(calls[0]?.init.body as string).has('from')).toBe(false);
  });

  it('fails when the recipient is rejected', async () => {
    const { fetch } = fakeFetch(201, {
      SMSMessageData: {
        Message: 'Sent to 0/1',
        Recipients: [{ statusCode: 403, number: '+2348031234567', status: 'InvalidPhoneNumber' }],
      },
    });
    const provider = new AfricasTalkingSmsProvider({
      username: 'talanta',
      apiKey: 'k',
      senderId: undefined,
      fetch,
    });

    await expect(provider.send({ to: '+2348031234567', body: 'x' })).rejects.toThrow(
      'InvalidPhoneNumber',
    );
  });

  it('fails on an HTTP error', async () => {
    const { fetch } = fakeFetch(401, 'The supplied authentication is invalid');
    const provider = new AfricasTalkingSmsProvider({
      username: 'talanta',
      apiKey: 'wrong',
      senderId: undefined,
      fetch,
    });

    await expect(provider.send({ to: '+2348031234567', body: 'x' })).rejects.toThrow('HTTP 401');
  });
});
