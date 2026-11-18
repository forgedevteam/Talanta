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

// Created by hand rather than with createDatabase(): on Windows the default
// template inherits the system code page (WIN1252), which cannot store emoji
// or most African-language characters. Talanta needs UTF-8.
const admin = server.getPgClient();
await admin.connect();
try {
  const existing = await admin.query<{ encoding: string }>(
    "select pg_encoding_to_char(encoding) as encoding from pg_database where datname = 'talanta'",
  );
  const encoding = existing.rows[0]?.encoding;
  if (encoding && encoding !== 'UTF8') {
    const backup = `talanta_${encoding.toLowerCase()}_${Date.now()}`;
    await admin.query(`alter database talanta rename to ${backup}`);
    console.log(`The old database used ${encoding}; kept it as ${backup} and created a UTF-8 one.`);
    console.log('Run db:migrate and db:seed-demo to fill it.');
  }
  if (encoding !== 'UTF8') {
    await admin.query(
      "create database talanta encoding 'UTF8' lc_collate 'C' lc_ctype 'C' template template0",
    );
  }
} finally {
  await admin.end();
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
