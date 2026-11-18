import { HttpStatus, Inject, Injectable } from '@nestjs/common';
import { and, eq, inArray } from 'drizzle-orm';

import { AppError } from '../../common/errors/app-error.js';
import { uuidv7 } from '../../common/ids/uuidv7.js';
import { RateLimiter } from '../../common/rate-limit/rate-limiter.js';
import { DATABASE, type Database } from '../../database/database.js';
import { media, type Media } from '../../database/schema/index.js';
import { MediaDto } from './dto/media.dto.js';
import { processUpload, type MediaPurpose } from './media-file.js';
import { MEDIA_STORAGE, type MediaStorage } from './media-storage.js';

export type { Media };

const UPLOADS_PER_DAY = 150;

/** Owns uploaded files. Other modules attach them by id, after asking whose they are. */
@Injectable()
export class MediaService {
  constructor(
    @Inject(DATABASE) private readonly db: Database,
    @Inject(MEDIA_STORAGE) private readonly storage: MediaStorage,
    private readonly rateLimiter: RateLimiter,
  ) {}

  async upload(ownerId: string, data: Buffer, purpose: MediaPurpose): Promise<MediaDto> {
    const limit = await this.rateLimiter.consume(`upload:${ownerId}`, {
      limit: UPLOADS_PER_DAY,
      windowSeconds: 86_400,
    });
    if (!limit.allowed) {
      throw new AppError(
        HttpStatus.TOO_MANY_REQUESTS,
        'rate_limited',
        'You have uploaded a lot today. Try again tomorrow.',
        { retryAfterSeconds: limit.retryAfterSeconds },
      );
    }

    const file = await processUpload(data, purpose);
    const id = uuidv7();
    // Unguessable and unrelated to the person or the original file name.
    const storageKey = `${file.kind}s/${id}.${file.extension}`;
    await this.storage.put(storageKey, file.data);
    try {
      const [row] = await this.db
        .insert(media)
        .values({
          id,
          ownerId,
          kind: file.kind,
          mimeType: file.mimeType,
          storageKey,
          bytes: file.data.length,
          width: file.width,
          height: file.height,
        })
        .returning();
      if (!row) throw new Error('Media insert returned no row');
      return this.toDto(row);
    } catch (error) {
      await this.storage.delete(storageKey);
      throw error;
    }
  }

  /** The caller's own files among `ids`, in the order asked for. Missing or foreign ids are left out. */
  async findOwned(ownerId: string, ids: readonly string[]): Promise<Media[]> {
    if (ids.length === 0) return [];
    const rows = await this.db
      .select()
      .from(media)
      .where(and(eq(media.ownerId, ownerId), inArray(media.id, [...ids])));
    const byId = new Map(rows.map((row) => [row.id, row]));
    return ids.flatMap((id) => {
      const row = byId.get(id);
      return row ? [row] : [];
    });
  }

  async findByIds(ids: readonly string[]): Promise<Map<string, Media>> {
    if (ids.length === 0) return new Map();
    const rows = await this.db
      .select()
      .from(media)
      .where(inArray(media.id, [...ids]));
    return new Map(rows.map((row) => [row.id, row]));
  }

  urlFor(row: Media): string {
    return this.storage.urlFor(row.storageKey);
  }

  toDto(row: Media): MediaDto {
    return {
      id: row.id,
      kind: row.kind,
      url: this.urlFor(row),
      width: row.width,
      height: row.height,
    };
  }

  /** Removes the files a closed account uploaded. */
  async deleteAllForOwner(ownerId: string): Promise<void> {
    const rows = await this.db
      .delete(media)
      .where(eq(media.ownerId, ownerId))
      .returning({ storageKey: media.storageKey });
    await Promise.all(rows.map((row) => this.storage.delete(row.storageKey)));
  }
}
