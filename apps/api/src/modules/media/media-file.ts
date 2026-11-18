import { HttpStatus } from '@nestjs/common';
import sharp from 'sharp';

import { AppError } from '../../common/errors/app-error.js';

export const MAX_IMAGE_BYTES = 12 * 1024 * 1024;
export const MAX_VIDEO_BYTES = 60 * 1024 * 1024;
/** Decoding bombs: a small file that expands to a huge bitmap. */
const MAX_INPUT_PIXELS = 50_000_000;

export type MediaPurpose = 'post' | 'avatar';

export interface ProcessedMedia {
  readonly kind: 'image' | 'video';
  readonly mimeType: string;
  readonly extension: string;
  readonly data: Buffer;
  readonly width: number | null;
  readonly height: number | null;
}

type Detected =
  | { kind: 'image' }
  | { kind: 'video'; mimeType: 'video/mp4' | 'video/quicktime'; extension: 'mp4' | 'mov' };

const unsupported = (): AppError =>
  new AppError(
    HttpStatus.UNSUPPORTED_MEDIA_TYPE,
    'media_unsupported',
    'Send a JPEG, PNG or WebP photo, or an MP4 video.',
  );

const tooLarge = (kind: 'image' | 'video'): AppError =>
  new AppError(
    HttpStatus.PAYLOAD_TOO_LARGE,
    'media_too_large',
    kind === 'image'
      ? 'Photos can be up to 12 MB.'
      : 'Videos can be up to 60 MB. Trim it or record a shorter one.',
  );

const ascii = (data: Buffer, start: number, end: number): string =>
  data.subarray(start, end).toString('latin1');

/** Brands of ISO media files that are video, not HEIF/AVIF stills. */
const VIDEO_BRANDS = new Set([
  'isom',
  'iso2',
  'iso4',
  'iso5',
  'iso6',
  'mp41',
  'mp42',
  'avc1',
  'M4V ',
  'MSNV',
  '3gp4',
  '3gp5',
  '3gp6',
  'dash',
]);

/**
 * Decides what a file is from its first bytes. The name and the type the
 * client claims are ignored: both are trivially forged.
 */
export function detect(data: Buffer): Detected {
  if (data.length < 16) throw unsupported();
  const isJpeg = data[0] === 0xff && data[1] === 0xd8 && data[2] === 0xff;
  const isPng = ascii(data, 1, 4) === 'PNG' && data[0] === 0x89;
  const isWebp = ascii(data, 0, 4) === 'RIFF' && ascii(data, 8, 12) === 'WEBP';
  if (isJpeg || isPng || isWebp) return { kind: 'image' };

  if (ascii(data, 4, 8) === 'ftyp') {
    const brand = ascii(data, 8, 12);
    if (brand === 'qt  ') return { kind: 'video', mimeType: 'video/quicktime', extension: 'mov' };
    if (VIDEO_BRANDS.has(brand)) return { kind: 'video', mimeType: 'video/mp4', extension: 'mp4' };
  }
  throw unsupported();
}

/**
 * Checks an upload and prepares it for storage. Photos are decoded and
 * re-encoded, which drops every byte of the original apart from the
 * picture: hidden payloads, and metadata such as where it was taken.
 */
export async function processUpload(data: Buffer, purpose: MediaPurpose): Promise<ProcessedMedia> {
  const detected = detect(data);

  if (detected.kind === 'video') {
    if (purpose === 'avatar') throw unsupported();
    if (data.length > MAX_VIDEO_BYTES) throw tooLarge('video');
    return { ...detected, data, width: null, height: null };
  }

  if (data.length > MAX_IMAGE_BYTES) throw tooLarge('image');
  try {
    const pipeline = sharp(data, { limitInputPixels: MAX_INPUT_PIXELS, failOn: 'error' })
      // Apply the camera's orientation before the metadata that holds it is dropped.
      .rotate();
    const resized =
      purpose === 'avatar'
        ? pipeline.resize(640, 640, { fit: 'cover', position: 'attention' })
        : pipeline.resize(1600, 1600, { fit: 'inside', withoutEnlargement: true });
    const { data: output, info } = await resized
      .jpeg({ quality: 82, mozjpeg: true })
      .toBuffer({ resolveWithObject: true });
    return {
      kind: 'image',
      mimeType: 'image/jpeg',
      extension: 'jpg',
      data: output,
      width: info.width,
      height: info.height,
    };
  } catch {
    // Truncated, corrupt or hostile: the decoder refused it.
    throw unsupported();
  }
}
