import { existsSync } from 'node:fs';
import { join } from 'node:path';

import EmbeddedPostgres from 'embedded-postgres';

// Runs a real PostgreSQL 16 server from node_modules for machines without
// Docker. Same credentials and port as docker-compose.yml, so DATABASE_URL
// is identical either way. Data lives in apps/api/.data/postgres.

const dataDir = join(process.cwd(), '.data', 'postgres');
const port = Number(process.env.PGPORT ?? 5432);

const server = new EmbeddedPostgres({
  databaseDir: dataDir,
  user: 'talanta',
  password: 'talanta',
  port,
  persistent: true,
  onLog: () => undefined,
  onError: (message) => {
    console.error(message);
  },
});

if (!existsSync(join(dataDir, 'PG_VERSION'))) {
  console.log('Creating a new local database cluster...');
  await server.initialise();
}

await server.start();

try {
  await server.createDatabase('talanta');
} catch {
  // Already exists from a previous run.
}

console.log(`PostgreSQL is running on postgres://talanta:talanta@localhost:${port}/talanta`);
console.log('Press Ctrl+C to stop.');

let stopping = false;
const stop = async (): Promise<void> => {
  if (stopping) return;
  stopping = true;
  await server.stop();
  process.exit(0);
};

process.on('SIGINT', () => void stop());
process.on('SIGTERM', () => void stop());
