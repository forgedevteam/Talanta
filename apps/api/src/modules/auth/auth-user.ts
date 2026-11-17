import type { Request } from 'express';

import type { UserRole } from '../users/users.service.js';

/** Who is making the request, as proven by the access token. */
export interface AuthUser {
  readonly id: string;
  /** The sign-in this token descends from. Stays the same across refreshes. */
  readonly sessionId: string;
  readonly role: UserRole;
}

export interface AuthenticatedRequest extends Request {
  user?: AuthUser;
}
