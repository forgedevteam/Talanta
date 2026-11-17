import { drizzle } from 'drizzle-orm/node-postgres';
import { migrate } from 'drizzle-orm/node-postgres/migrator';
import pg from 'pg';

import { MIGRATIONS_FOLDER } from './migrations.js';
import * as schema from './schema/index.js';
import { seedTalentCategories } from './seed-data.js';

// Applies pending migrations, then refreshes reference data.
// Run before starting a new release: `node dist/database/migrate.js`.

try {
  process.loadEnvFile();
} catch {
  // No .env file: rely on the real environment.
}

const url = process.env.DATABASE_URL;
if (!url) throw new Error('DATABASE_URL is not set');

const pool = new pg.Pool({ connectionString: url, max: 1 });
try {
  const db = drizzle(pool, { schema });
  await migrate(db, { migrationsFolder: MIGRATIONS_FOLDER });
  await seedTalentCategories(db);
  console.log('Database is up to date.');
} finally {
  await pool.end();
}
