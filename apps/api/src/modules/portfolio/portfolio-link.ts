import { HttpStatus } from '@nestjs/common';

import { AppError } from '../../common/errors/app-error.js';
import type { PortfolioItem } from '../../database/schema/index.js';

export type PortfolioPlatform = PortfolioItem['platform'];

const PLATFORM_HOSTS: readonly (readonly [PortfolioPlatform, readonly string[]])[] = [
  ['youtube', ['youtube.com', 'youtu.be']],
  ['tiktok', ['tiktok.com']],
  ['instagram', ['instagram.com']],
  ['facebook', ['facebook.com', 'fb.watch']],
  ['audiomack', ['audiomack.com']],
  ['boomplay', ['boomplay.com', 'boomplaymusic.com']],
  ['soundcloud', ['soundcloud.com']],
  ['spotify', ['spotify.com']],
];

const MAX_URL_LENGTH = 500;

const notAllowed = (message: string): AppError =>
  new AppError(HttpStatus.UNPROCESSABLE_ENTITY, 'link_not_allowed', message, {
    fields: { url: [message] },
  });

/**
 * Accepts a public https link and works out which platform it points to.
 * The server never fetches the URL, so there is no request to forge; the
 * checks keep obviously unsafe or deceptive links out of other people's feeds.
 */
export function checkPortfolioLink(raw: string): { url: string; platform: PortfolioPlatform } {
  if (raw.length > MAX_URL_LENGTH) throw notAllowed('That link is too long.');

  let parsed: URL;
  try {
    parsed = new URL(raw.trim());
  } catch {
    throw notAllowed('Paste a full link, starting with https://');
  }

  if (parsed.protocol !== 'https:') throw notAllowed('Only secure https:// links are accepted.');
  if (parsed.username || parsed.password) throw notAllowed('That link is not accepted.');

  const host = parsed.hostname.toLowerCase();
  // Bare IPs and single-label hosts are never real portfolio pages.
  if (!host.includes('.') || /^[\d.]+$/.test(host) || host.startsWith('[')) {
    throw notAllowed('That link is not accepted.');
  }

  const platform =
    PLATFORM_HOSTS.find(([, hosts]) =>
      hosts.some((known) => host === known || host.endsWith(`.${known}`)),
    )?.[0] ?? 'other';

  return { url: parsed.toString(), platform };
}
