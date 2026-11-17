export type IdentityProvider = 'google' | 'apple';

export interface VerifiedIdentity {
  readonly provider: IdentityProvider;
  /** The provider's stable id for the person (`sub`). */
  readonly subject: string;
  readonly email: string | null;
  readonly emailVerified: boolean;
  readonly displayName: string | null;
}

/**
 * Port for "Continue with Google" and "Sign in with Apple". The app obtains an
 * ID token from the provider SDK and posts it; an implementation checks the
 * signature, audience and expiry against the provider's published keys.
 *
 * Nothing implements this yet. When one does, sign-in ends the same way phone
 * sign-in does: find or create the user, then `SessionService.start`.
 */
export interface IdTokenVerifier {
  readonly provider: IdentityProvider;
  verify(idToken: string): Promise<VerifiedIdentity>;
}
