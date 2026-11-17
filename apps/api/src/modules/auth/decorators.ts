import {
  createParamDecorator,
  HttpStatus,
  SetMetadata,
  type ExecutionContext,
} from '@nestjs/common';

import { AppError } from '../../common/errors/app-error.js';
import type { AuthenticatedRequest, AuthUser } from './auth-user.js';

export const IS_PUBLIC = 'talanta:isPublic';

/** Every route needs a valid access token unless it is marked with this. */
export const Public = (): MethodDecorator & ClassDecorator => SetMetadata(IS_PUBLIC, true);

/** The signed-in user, for routes behind the access-token guard. */
export const CurrentUser = createParamDecorator(
  (_data: unknown, context: ExecutionContext): AuthUser => {
    const { user } = context.switchToHttp().getRequest<AuthenticatedRequest>();
    if (!user) throw new AppError(HttpStatus.UNAUTHORIZED, 'unauthorized', 'Sign in to continue.');
    return user;
  },
);
