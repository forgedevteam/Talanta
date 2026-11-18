import { Controller, Delete, Get, HttpCode, HttpStatus, Param, Post, Query } from '@nestjs/common';
import {
  ApiBearerAuth,
  ApiDefaultResponse,
  ApiOkResponse,
  ApiOperation,
  ApiTags,
} from '@nestjs/swagger';

import { ProblemDto } from '../../common/errors/problem.dto.js';
import { CursorQueryDto } from '../../common/pagination/cursor.js';
import { CurrentUser, type AuthUser } from '../auth/index.js';
import { UsernameQueryDto } from '../profiles/dto/profile.dto.js';
import { CreatorsService } from './creators.service.js';
import {
  CreatorPageDto,
  CreatorProfileDto,
  CreatorQueryDto,
  FollowingFeedDto,
  FollowStateDto,
} from './dto/creator.dto.js';

@ApiTags('creators')
@ApiBearerAuth()
@ApiDefaultResponse({ type: ProblemDto })
@Controller()
export class CreatorsController {
  constructor(private readonly creators: CreatorsService) {}

  @Get('creators')
  @ApiOperation({ summary: 'Find creators by name, talent and city' })
  @ApiOkResponse({ type: CreatorPageDto })
  searchCreators(@Query() query: CreatorQueryDto): Promise<CreatorPageDto> {
    return this.creators.search(query);
  }

  @Get('creators/:username')
  @ApiOperation({ summary: 'A creator’s public profile and portfolio' })
  @ApiOkResponse({ type: CreatorProfileDto })
  getCreator(
    @CurrentUser() user: AuthUser,
    @Param() params: UsernameQueryDto,
  ): Promise<CreatorProfileDto> {
    return this.creators.profile(params.username, user.id);
  }

  @Post('creators/:username/follow')
  @HttpCode(HttpStatus.OK)
  @ApiOperation({ summary: 'Follow a creator' })
  @ApiOkResponse({ type: FollowStateDto })
  followCreator(
    @CurrentUser() user: AuthUser,
    @Param() params: UsernameQueryDto,
  ): Promise<FollowStateDto> {
    return this.creators.follow(params.username, user.id);
  }

  @Delete('creators/:username/follow')
  @ApiOperation({ summary: 'Stop following a creator' })
  @ApiOkResponse({ type: FollowStateDto })
  unfollowCreator(
    @CurrentUser() user: AuthUser,
    @Param() params: UsernameQueryDto,
  ): Promise<FollowStateDto> {
    return this.creators.unfollow(params.username, user.id);
  }

  @Get('feed/following')
  @ApiOperation({ summary: 'New work from the creators I follow' })
  @ApiOkResponse({ type: FollowingFeedDto })
  getFollowingFeed(
    @CurrentUser() user: AuthUser,
    @Query() query: CursorQueryDto,
  ): Promise<FollowingFeedDto> {
    return this.creators.followingFeed(user.id, query);
  }
}
