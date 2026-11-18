import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { Transform } from 'class-transformer';
import {
  ArrayMaxSize,
  IsArray,
  IsBoolean,
  IsIn,
  IsOptional,
  IsString,
  Length,
  Matches,
  MaxLength,
} from 'class-validator';

import { UUID_PATTERN } from '../../../common/ids/uuidv7.js';
import { CursorQueryDto } from '../../../common/pagination/cursor.js';
import { CleanMultiline } from '../../../common/validation/transforms.js';
import { MediaDto } from '../../media/dto/media.dto.js';
import { PersonSummaryDto } from '../../profiles/dto/person.dto.js';

export const POST_KINDS = ['text', 'photo', 'video'] as const;
export const FEED_TABS = ['for_you', 'following'] as const;
export const MAX_PHOTOS_PER_POST = 10;

export class PostDto {
  @ApiProperty({ format: 'uuid' })
  id: string;

  @ApiProperty({ type: () => PersonSummaryDto })
  author: PersonSummaryDto;

  @ApiProperty({ enum: POST_KINDS, enumName: 'PostKind' })
  kind: (typeof POST_KINDS)[number];

  @ApiProperty({ type: String, nullable: true, example: 'New song for my mama. One take.' })
  body: string | null;

  @ApiProperty({ type: () => [MediaDto] })
  media: MediaDto[];

  @ApiProperty({ description: 'A vertical video that also plays in Reels.' })
  isReel: boolean;

  @ApiProperty()
  likeCount: number;

  @ApiProperty()
  commentCount: number;

  @ApiProperty()
  shareCount: number;

  @ApiProperty()
  likedByMe: boolean;

  @ApiProperty()
  isMine: boolean;

  @ApiProperty()
  createdAt: Date;
}

export class PostPageDto {
  @ApiProperty({ type: () => [PostDto] })
  items: PostDto[];

  @ApiProperty({ type: String, nullable: true })
  nextCursor: string | null;
}

export class CreatePostDto {
  @ApiPropertyOptional({ maxLength: 2200, example: 'Rehearsal for Saturday. Who is coming?' })
  @IsOptional()
  @CleanMultiline()
  @IsString()
  @MaxLength(2200, { message: 'Keep it under 2,200 characters.' })
  body?: string;

  @ApiPropertyOptional({
    type: [String],
    description: `Uploaded files, in display order: up to ${MAX_PHOTOS_PER_POST} photos, or one video.`,
  })
  @IsOptional()
  @IsArray()
  @ArrayMaxSize(MAX_PHOTOS_PER_POST, { message: `Up to ${MAX_PHOTOS_PER_POST} photos per post.` })
  @Matches(UUID_PATTERN, { each: true })
  mediaIds?: string[];

  @ApiPropertyOptional({ description: 'Show this video in Reels too.' })
  @IsOptional()
  @IsBoolean()
  isReel?: boolean;
}

export class FeedQueryDto extends CursorQueryDto {
  @ApiPropertyOptional({ enum: FEED_TABS, enumName: 'FeedTab', default: 'for_you' })
  @IsOptional()
  @IsIn(FEED_TABS)
  tab?: (typeof FEED_TABS)[number];
}

export class CreatorPostsQueryDto extends CursorQueryDto {
  @ApiPropertyOptional({ description: 'Only reels.' })
  @IsOptional()
  @Transform(({ value }: { value: unknown }) => value === true || value === 'true')
  @IsBoolean()
  reels?: boolean;
}

export class LikeStateDto {
  @ApiProperty()
  liked: boolean;

  @ApiProperty()
  likeCount: number;
}

export class ShareDto {
  @ApiProperty({ example: 'https://talanta.app/p/0196f0b2-7c1e-7d43-9a51-2a8f0c3b9e10' })
  url: string;

  @ApiProperty()
  shareCount: number;
}

export class CommentDto {
  @ApiProperty({ format: 'uuid' })
  id: string;

  @ApiProperty({ format: 'uuid' })
  postId: string;

  @ApiProperty({ type: () => PersonSummaryDto })
  author: PersonSummaryDto;

  @ApiProperty()
  body: string;

  @ApiProperty({ description: 'I can delete it: I wrote it, or it is on my post.' })
  canDelete: boolean;

  @ApiProperty()
  createdAt: Date;
}

export class CommentPageDto {
  @ApiProperty({ type: () => [CommentDto] })
  items: CommentDto[];

  @ApiProperty({ type: String, nullable: true })
  nextCursor: string | null;
}

export class CreateCommentDto {
  @ApiProperty({ minLength: 1, maxLength: 500 })
  @CleanMultiline()
  @IsString()
  @Length(1, 500, { message: 'Write something, up to 500 characters.' })
  body: string;
}
