import createClient, { type ClientOptions, type Middleware } from 'openapi-fetch';

import type { components, paths } from './schema.js';

export type * from './schema.js';

export type Schemas = components['schemas'];
export type Problem = Schemas['ProblemDto'];
export type ErrorCode = Schemas['ErrorCode'];
export type Me = Schemas['MeDto'];
export type TokenPair = Schemas['TokenPairDto'];
export type TalentCategory = Schemas['TalentCategoryDto'];

export type TalantaClient = ReturnType<typeof createClient<paths>>;

export interface TalantaClientOptions extends Omit<ClientOptions, 'baseUrl'> {
  /** Origin of the API, for example `https://api.talanta.app`. No trailing slash. */
  readonly baseUrl: string;
  /** Called before each request. Return the access token to send, or null for none. */
  readonly getAccessToken?: () => Promise<string | null> | string | null;
}

/** A typed client over `fetch`. Every path, body and response comes from openapi.json. */
export function createTalantaClient(options: TalantaClientOptions): TalantaClient {
  const { getAccessToken, ...clientOptions } = options;
  const client = createClient<paths>(clientOptions);

  if (getAccessToken) {
    const auth: Middleware = {
      async onRequest({ request }) {
        const token = await getAccessToken();
        if (token) request.headers.set('Authorization', `Bearer ${token}`);
        return request;
      },
    };
    client.use(auth);
  }

  return client;
}

/** True when an error body from the API has the `ProblemDto` shape. */
export function isProblem(value: unknown): value is Problem {
  return (
    typeof value === 'object' &&
    value !== null &&
    typeof (value as { code?: unknown }).code === 'string' &&
    typeof (value as { message?: unknown }).message === 'string'
  );
}
