import { Body, Controller, Delete, Get, Put } from '@nestjs/common';
import {
  ApiBearerAuth,
  ApiDefaultResponse,
  ApiOkResponse,
  ApiOperation,
  ApiTags,
} from '@nestjs/swagger';

import { ProblemDto } from '../../common/errors/problem.dto.js';
import { CurrentUser, type AuthUser } from '../auth/index.js';
import { UpdateProfileDto } from '../profiles/dto/profile.dto.js';
import { SetTalentsDto } from '../talents/dto/talent.dto.js';
import { AccountService } from './account.service.js';
import { MeDto, SetAvatarDto } from './dto/me.dto.js';

@ApiTags('me')
@ApiBearerAuth()
@ApiDefaultResponse({ type: ProblemDto })
@Controller('me')
export class MeController {
  constructor(private readonly account: AccountService) {}

  @Get()
  @ApiOperation({ summary: 'The signed-in account, profile, talents and next onboarding step' })
  @ApiOkResponse({ type: MeDto })
  getMe(@CurrentUser() user: AuthUser): Promise<MeDto> {
    return this.account.getMe(user.id);
  }

  @Put('talents')
  @ApiOperation({ summary: 'Replace the talents on my profile' })
  @ApiOkResponse({ type: MeDto })
  setMyTalents(@CurrentUser() user: AuthUser, @Body() body: SetTalentsDto): Promise<MeDto> {
    return this.account.setTalents(user.id, body.categoryIds, body.primaryCategoryId);
  }

  @Put('profile')
  @ApiOperation({ summary: 'Create or update my profile' })
  @ApiOkResponse({ type: MeDto })
  saveMyProfile(@CurrentUser() user: AuthUser, @Body() body: UpdateProfileDto): Promise<MeDto> {
    return this.account.saveProfile(user.id, body, body.dateOfBirth);
  }

  @Put('avatar')
  @ApiOperation({ summary: 'Use an uploaded photo as my profile picture' })
  @ApiOkResponse({ type: MeDto })
  setMyAvatar(@CurrentUser() user: AuthUser, @Body() body: SetAvatarDto): Promise<MeDto> {
    return this.account.setAvatar(user.id, body.mediaId);
  }

  @Delete('avatar')
  @ApiOperation({ summary: 'Remove my profile picture' })
  @ApiOkResponse({ type: MeDto })
  removeMyAvatar(@CurrentUser() user: AuthUser): Promise<MeDto> {
    return this.account.setAvatar(user.id, null);
  }
}
