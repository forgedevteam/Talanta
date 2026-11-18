import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { IsIn, IsOptional } from 'class-validator';

export const MEDIA_KINDS = ['image', 'video'] as const;
export const MEDIA_PURPOSES = ['post', 'avatar'] as const;

export class MediaDto {
  @ApiProperty({ format: 'uuid' })
  id: string;

  @ApiProperty({ enum: MEDIA_KINDS, enumName: 'MediaKind' })
  kind: (typeof MEDIA_KINDS)[number];

  @ApiProperty({
    example: '/media/images/0196f0b2-7c1e-7d43-9a51-2a8f0c3b9e10.jpg',
    description: 'Absolute, or relative to the API origin.',
  })
  url: string;

  @ApiProperty({ type: Number, nullable: true })
  width: number | null;

  @ApiProperty({ type: Number, nullable: true })
  height: number | null;
}

export class UploadQueryDto {
  @ApiPropertyOptional({
    enum: MEDIA_PURPOSES,
    enumName: 'MediaPurpose',
    description: 'Avatars are cropped square.',
  })
  @IsOptional()
  @IsIn(MEDIA_PURPOSES)
  purpose?: (typeof MEDIA_PURPOSES)[number];
}
