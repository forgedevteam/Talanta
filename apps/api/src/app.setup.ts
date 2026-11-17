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
  app.enableCors({ origin: [...config.corsOrigins], maxAge: 600 });
  app.setGlobalPrefix(API_PREFIX, { exclude: ['health', 'health/ready'] });
  app.useGlobalPipes(createValidationPipe());
  app.useGlobalFilters(new ProblemFilter());
  app.enableShutdownHooks();
}
