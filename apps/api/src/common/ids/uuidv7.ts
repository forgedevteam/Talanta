import { randomBytes } from 'node:crypto';

/**
 * RFC 9562 UUID version 7: a 48-bit Unix millisecond timestamp followed by
 * random bits. IDs sort by creation time, which keeps B-tree inserts local
 * and makes `ORDER BY id` a cheap stand-in for `ORDER BY created_at`.
 */
export function uuidv7(timestampMs: number = Date.now()): string {
  const bytes = randomBytes(16);
  bytes.writeUIntBE(timestampMs, 0, 6);
  bytes[6] = ((bytes[6] ?? 0) & 0x0f) | 0x70;
  bytes[8] = ((bytes[8] ?? 0) & 0x3f) | 0x80;

  const hex = bytes.toString('hex');
  return [
    hex.slice(0, 8),
    hex.slice(8, 12),
    hex.slice(12, 16),
    hex.slice(16, 20),
    hex.slice(20),
  ].join('-');
}

export const UUID_PATTERN =
  /^[0-9a-f]{8}-[0-9a-f]{4}-[1-8][0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$/;
