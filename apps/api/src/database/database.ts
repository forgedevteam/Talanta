import type { PgDatabase, PgQueryResultHKT } from 'drizzle-orm/pg-core';

import type * as schema from './schema/index.js';

export const DATABASE = Symbol('DATABASE');

/**
 * Driver-agnostic handle. node-postgres in every deployed environment and
 * PGlite in tests both satisfy it, and so does an open transaction.
 */
export type Database = PgDatabase<PgQueryResultHKT, typeof schema>;

interface PostgresError {
  code?: unknown;
  cause?: unknown;
}

const UNIQUE_VIOLATION = '23505';

/** True when the error, or the driver error it wraps, is a unique-constraint violation. */
export function isUniqueViolation(error: unknown): boolean {
  let current: unknown = error;
  for (let depth = 0; depth < 4 && typeof current === 'object' && current !== null; depth += 1) {
    const candidate = current as PostgresError;
    if (candidate.code === UNIQUE_VIOLATION) return true;
    current = candidate.cause;
  }
  return false;
}
