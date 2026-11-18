import { Controller, HttpStatus, Post, Query, UploadedFile, UseInterceptors } from '@nestjs/common';
import { FileInterceptor } from '@nestjs/platform-express';
import {
  ApiBearerAuth,
  ApiBody,
  ApiConsumes,
  ApiCreatedResponse,
  ApiDefaultResponse,
  ApiOperation,
  ApiTags,
} from '@nestjs/swagger';

import { AppError } from '../../common/errors/app-error.js';
import { ProblemDto } from '../../common/errors/problem.dto.js';
import { CurrentUser, type AuthUser } from '../auth/index.js';
import { MediaDto, UploadQueryDto } from './dto/media.dto.js';
import { MAX_VIDEO_BYTES } from './media-file.js';
import { MediaService } from './media.service.js';

@ApiTags('media')
@ApiBearerAuth()
@ApiDefaultResponse({ type: ProblemDto })
@Controller('media')
export class MediaController {
  constructor(private readonly media: MediaService) {}

  @Post()
  @UseInterceptors(
    // Without a destination the parser keeps the file in memory, never on disk.
    FileInterceptor('file', {
      // The parser stops reading at the limit, so an oversized upload costs little.
      limits: { fileSize: MAX_VIDEO_BYTES, files: 1, fields: 2, parts: 3 },
    }),
  )
  @ApiOperation({ summary: 'Upload a photo or a video, to attach to a post or use as my picture' })
  @ApiConsumes('multipart/form-data')
  @ApiBody({
    schema: {
      type: 'object',
      required: ['file'],
      properties: { file: { type: 'string', format: 'binary' } },
    },
  })
  @ApiCreatedResponse({ type: MediaDto })
  uploadMedia(
    @CurrentUser() user: AuthUser,
    @Query() query: UploadQueryDto,
    @UploadedFile() file: { buffer: Buffer } | undefined,
  ): Promise<MediaDto> {
    if (!file) {
      throw new AppError(
        HttpStatus.UNPROCESSABLE_ENTITY,
        'validation_failed',
        'Attach the file as "file".',
        { fields: { file: ['Choose a photo or a video.'] } },
      );
    }
    return this.media.upload(user.id, file.buffer, query.purpose ?? 'post');
  }
}
