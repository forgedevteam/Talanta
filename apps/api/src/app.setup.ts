import type { ServerResponse } from 'node:http';
import { resolve } from 'node:path';

import type { NestExpressApplication } from '@nestjs/platform-express';
import helmet from 'helmet';

import { ProblemFilter } from './common/errors/problem.filter.js';
import { createValidationPipe } from './common/validation/validation.pipe.js';
import type { AppConfig } from './config/env.js';

export const API_PREFIX = 'v1';

/**
 * Everything that shapes HTTP behaviour, in one place, so the server, the
 * tests and the OpenAPI generator all run the same application.
 */
export function configureApp(app: NestExpressApplication, config: AppConfig): void {
  // Needed for the real client IP behind a load balancer; rate limits depend on it.
  app.set('trust proxy', config.trustProxyHops);
  app.disable('x-powered-by');
  app.use(helmet());
  // Every request body is small JSON; anything bigger is a mistake or an attack.
  app.useBodyParser('json', { limit: '64kb' });
  app.enableCors({ origin: [...config.corsOrigins], maxAge: 600 });
  if (!config.media.publicBaseUrl) {
    // Uploaded files, when no CDN serves them. Names are unguessable ids; the
    // headers stop a browser from ever treating a file as a page.
    app.useStaticAssets(resolve(config.media.dir), {
      prefix: '/media/',
      index: false,
      dotfiles: 'deny',
      fallthrough: false,
      maxAge: '30d',
      immutable: true,
      setHeaders: (response: ServerResponse) => {
        response.setHeader('X-Content-Type-Options', 'nosniff');
        response.setHeader('Content-Security-Policy', "default-src 'none'; sandbox");
        response.setHeader('Cross-Origin-Resource-Policy', 'cross-origin');
      },
    });
  }
  app.setGlobalPrefix(API_PREFIX, { exclude: ['health', 'health/ready'] });
  app.useGlobalPipes(createValidationPipe());
  app.useGlobalFilters(new ProblemFilter());
  app.enableShutdownHooks();
}
