import 'reflect-metadata';

import { mkdir, writeFile } from 'node:fs/promises';
import { dirname } from 'node:path';
import { fileURLToPath } from 'node:url';

import { NestFactory } from '@nestjs/core';
import type { NestExpressApplication } from '@nestjs/platform-express';

import { AppModule } from '../app.module.js';
import { configureApp } from '../app.setup.js';
import { APP_CONFIG } from '../config/config.module.js';
import type { AppConfig } from '../config/env.js';
import { buildOpenApiDocument } from '../openapi.js';

// Writes packages/api-contract/openapi.json from the controllers and DTOs.
// The app is assembled but never started, so no database or Redis is needed:
// the values below only have to pass config validation.

const placeholder = 'not-used-while-generating-the-openapi-document';
process.env.NODE_ENV = 'development';
process.env.DATABASE_URL ??= 'postgres://localhost/unused';
process.env.JWT_ACCESS_SECRET ??= placeholder;
process.env.OTP_SECRET ??= placeholder;
delete process.env.REDIS_URL;

const target = fileURLToPath(
  new URL('../../../../packages/api-contract/openapi.json', import.meta.url),
);

const app = await NestFactory.create<NestExpressApplication>(AppModule, { logger: ['error'] });
configureApp(app, app.get<AppConfig>(APP_CONFIG));

const document = buildOpenApiDocument(app);
await mkdir(dirname(target), { recursive: true });
await writeFile(target, `${JSON.stringify(document, null, 2)}\n`);
await app.close();

console.log(`Wrote ${target}`);
