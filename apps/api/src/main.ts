import 'reflect-metadata';

import { Logger } from '@nestjs/common';
import { NestFactory } from '@nestjs/core';
import type { NestExpressApplication } from '@nestjs/platform-express';
import { SwaggerModule } from '@nestjs/swagger';

import { AppModule } from './app.module.js';
import { configureApp } from './app.setup.js';
import { APP_CONFIG } from './config/config.module.js';
import type { AppConfig } from './config/env.js';
import { buildOpenApiDocument } from './openapi.js';

try {
  process.loadEnvFile();
} catch {
  // No .env file: rely on the real environment.
}

const app = await NestFactory.create<NestExpressApplication>(AppModule);
const config = app.get<AppConfig>(APP_CONFIG);
configureApp(app, config);

if (!config.isProduction) {
  SwaggerModule.setup('docs', app, buildOpenApiDocument(app));
}

await app.listen(config.port);
new Logger('Talanta').log(`API listening on port ${config.port} (${config.environment})`);
