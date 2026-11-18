import { HttpStatus, Injectable, type CanActivate, type ExecutionContext } from '@nestjs/common';
import { Reflector } from '@nestjs/core';

import { AppError } from '../../../common/errors/app-error.js';
import type { AuthenticatedRequest } from '../auth-user.js';
import { IS_PUBLIC } from '../decorators.js';
import { UsersService } from '../../users/users.service.js';
import { TokenService } from '../tokens/token.service.js';

const BEARER = 'Bearer ';

/** Registered globally: routes are private unless marked `@Public()`. */
@Injectable()
export class AccessTokenGuard implements CanActivate {
  constructor(
    private readonly reflector: Reflector,
    private readonly tokens: TokenService,
    private readonly users: UsersService,
  ) {}

  async canActivate(context: ExecutionContext): Promise<boolean> {
    const isPublic = this.reflector.getAllAndOverride<boolean | undefined>(IS_PUBLIC, [
      context.getHandler(),
      context.getClass(),
    ]);
    if (isPublic) return true;

    const request = context.switchToHttp().getRequest<AuthenticatedRequest>();
    const header = request.headers.authorization;
    if (!header?.startsWith(BEARER)) {
      throw new AppError(HttpStatus.UNAUTHORIZED, 'unauthorized', 'Sign in to continue.');
    }
    const claims = await this.tokens.verify(header.slice(BEARER.length));

    // Tokens live 15 minutes. Checking the account on every request means a
    // suspension, deletion or role change takes effect immediately.
    const user = await this.users.findById(claims.id);
    if (user?.status !== 'active') {
      throw new AppError(HttpStatus.UNAUTHORIZED, 'unauthorized', 'Sign in to continue.');
    }
    request.user = { ...claims, role: user.role };
    return true;
  }
}
