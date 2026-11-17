import { fileURLToPath } from 'node:url';

/** Resolves from both `src/database` (tsx, tests) and `dist/database` (production build). */
export const MIGRATIONS_FOLDER = fileURLToPath(new URL('../../drizzle', import.meta.url));
