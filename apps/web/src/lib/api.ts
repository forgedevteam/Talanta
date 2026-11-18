import { createTalantaClient } from '@talanta/api-contract';

/** Typed client for server components and route handlers. */
export const api = createTalantaClient({
  baseUrl: process.env.API_BASE_URL ?? 'http://localhost:3000',
});
