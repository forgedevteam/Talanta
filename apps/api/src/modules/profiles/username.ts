export const USERNAME_MIN_LENGTH = 3;
export const USERNAME_MAX_LENGTH = 24;

/** Lower-case letters, digits and underscores. Stored and compared lower-case. */
export const USERNAME_PATTERN = /^[a-z0-9_]{3,24}$/;

/** Names that could pass for the platform itself or collide with a route. */
const RESERVED: ReadonlySet<string> = new Set([
  'about',
  'admin',
  'administrator',
  'api',
  'app',
  'challenges',
  'contact',
  'discover',
  'explore',
  'help',
  'home',
  'legal',
  'login',
  'logout',
  'me',
  'mod',
  'moderator',
  'official',
  'privacy',
  'root',
  'safety',
  'security',
  'settings',
  'signup',
  'sponsor',
  'sponsors',
  'staff',
  'support',
  'system',
  'talanta',
  'talanta_app',
  'talanta_official',
  'team',
  'terms',
  'verified',
  'www',
]);

export const isReservedUsername = (username: string): boolean => RESERVED.has(username);
