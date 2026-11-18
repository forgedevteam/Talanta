import { Body, Controller, HttpCode, HttpStatus, Ip, Post } from '@nestjs/common';
import {
  ApiDefaultResponse,
  ApiNoContentResponse,
  ApiOkResponse,
  ApiOperation,
  ApiTags,
} from '@nestjs/swagger';

import { ProblemDto } from '../../common/errors/problem.dto.js';
import { AuthService } from './auth.service.js';
import { Public } from './decorators.js';
import {
  AuthSessionDto,
  OtpChallengeDto,
  RefreshTokenDto,
  RequestOtpDto,
  TokenPairDto,
  VerifyOtpDto,
} from './dto/auth.dto.js';

@ApiTags('auth')
@ApiDefaultResponse({ type: ProblemDto })
@Public()
@Controller('auth')
export class AuthController {
  constructor(private readonly auth: AuthService) {}

  @Post('otp/request')
  @HttpCode(HttpStatus.OK)
  @ApiOperation({ summary: 'Text a sign-in code to a phone number' })
  @ApiOkResponse({ type: OtpChallengeDto })
  requestOtp(@Body() body: RequestOtpDto, @Ip() ip: string): Promise<OtpChallengeDto> {
    return this.auth.requestOtp(body, ip);
  }

  @Post('otp/verify')
  @HttpCode(HttpStatus.OK)
  @ApiOperation({ summary: 'Exchange a sign-in code for a session, creating the account if new' })
  @ApiOkResponse({ type: AuthSessionDto })
  verifyOtp(@Body() body: VerifyOtpDto, @Ip() ip: string): Promise<AuthSessionDto> {
    return this.auth.verifyOtp(body, ip);
  }

  @Post('refresh')
  @HttpCode(HttpStatus.OK)
  @ApiOperation({ summary: 'Trade a refresh token for a new token pair' })
  @ApiOkResponse({ type: TokenPairDto })
  refreshSession(@Body() body: RefreshTokenDto): Promise<TokenPairDto> {
    return this.auth.refresh(body.refreshToken);
  }

  @Post('logout')
  @HttpCode(HttpStatus.NO_CONTENT)
  @ApiOperation({ summary: 'End the session on this device' })
  @ApiNoContentResponse()
  signOut(@Body() body: RefreshTokenDto): Promise<void> {
    return this.auth.signOut(body.refreshToken);
  }
}
