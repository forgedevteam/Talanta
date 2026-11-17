import { timestamp, uuid } from 'drizzle-orm/pg-core';

import { uuidv7 } from '../../common/ids/uuidv7.js';

/* The builder types below are inferred by Drizzle and spelt out nowhere else. */
/* eslint-disable @typescript-eslint/explicit-module-boundary-types */

/** UUIDv7 primary key, generated in the application so it works on any Postgres version. */
export const id = () =>
  uuid('id')
    .primaryKey()
    .$defaultFn(() => uuidv7());

export const timestamptz = (name: string) => timestamp(name, { withTimezone: true, mode: 'date' });

/** Every table carries these two columns. */
export const timestamps = {
  createdAt: timestamptz('created_at').notNull().defaultNow(),
  updatedAt: timestamptz('updated_at')
    .notNull()
    .defaultNow()
    .$onUpdate(() => new Date()),
};
