import { Controller, Get, Query } from '@nestjs/common';
import {
  ApiBearerAuth,
  ApiDefaultResponse,
  ApiOkResponse,
  ApiOperation,
  ApiTags,
} from '@nestjs/swagger';

import { ProblemDto } from '../../common/errors/problem.dto.js';
import { CurrentUser, type AuthUser } from '../auth/index.js';
import { UsernameAvailabilityDto, UsernameQueryDto } from './dto/profile.dto.js';
import { ProfilesService } from './profiles.service.js';

@ApiTags('profiles')
@ApiBearerAuth()
@ApiDefaultResponse({ type: ProblemDto })
@Controller('profiles')
export class ProfilesController {
  constructor(private readonly profiles: ProfilesService) {}

  @Get('username-availability')
  @ApiOperation({ summary: 'Check whether a username can be claimed' })
  @ApiOkResponse({ type: UsernameAvailabilityDto })
  async checkUsername(
    @Query() query: UsernameQueryDto,
    @CurrentUser() user: AuthUser,
  ): Promise<UsernameAvailabilityDto> {
    return {
      username: query.username,
      status: await this.profiles.usernameStatus(query.username, user.id),
    };
  }
}
