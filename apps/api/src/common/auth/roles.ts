import {
  HttpStatus,
  Injectable,
  SetMetadata,
  type CanActivate,
  type ExecutionContext,
} from '@nestjs/common';
import { Reflector } from '@nestjs/core';

import { AppError } from '../errors/app-error.js';

export const REQUIRED_ROLE = 'talanta:requiredRole';
type Role = 'member' | 'sponsor' | 'admin';

/** Restricts a controller or route to one role. Checked after the access token. */
export const RequireRole = (role: Role): MethodDecorator & ClassDecorator =>
  SetMetadata(REQUIRED_ROLE, role);

interface RequestWithRole {
  user?: { role: Role };
}

@Injectable()
export class RoleGuard implements CanActivate {
  constructor(private readonly reflector: Reflector) {}

  canActivate(context: ExecutionContext): boolean {
    const required = this.reflector.getAllAndOverride<Role | undefined>(REQUIRED_ROLE, [
      context.getHandler(),
      context.getClass(),
    ]);
    if (!required) return true;
    const { user } = context.switchToHttp().getRequest<RequestWithRole>();
    if (user?.role !== required) {
      // Same answer as a missing route, so admin endpoints are not advertised.
      throw new AppError(HttpStatus.NOT_FOUND, 'not_found', 'Not found.');
    }
    return true;
  }
}
