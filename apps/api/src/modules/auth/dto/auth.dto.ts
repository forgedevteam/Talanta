import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { IsOptional, IsString, Length, Matches, MaxLength } from 'class-validator';

import { CleanText, Uppercase } from '../../../common/validation/transforms.js';
import { MeDto } from '../../account/dto/me.dto.js';

const COUNTRY_PATTERN = /^[A-Z]{2}$/;
const CODE_PATTERN = /^\d{6}$/;

export class RequestOtpDto {
  @ApiProperty({
    example: '6 71 23 45 67',
    description: 'As typed: national format together with `country`, or full international format.',
  })
  @IsString()
  @Length(4, 24, { message: 'Enter your phone number.' })
  phone: string;

  @ApiPropertyOptional({
    example: 'CM',
    description: 'ISO 3166-1 alpha-2 country chosen in the picker.',
  })
  @IsOptional()
  @Uppercase()
  @Matches(COUNTRY_PATTERN, { message: 'Country must be a two-letter code.' })
  country?: string;
}

export class OtpChallengeDto {
  @ApiProperty({
    example: '+237671234567',
    description: 'The number the code was sent to, in E.164.',
  })
  phone: string;

  @ApiProperty({
    example: '+237 6 71 23 45 67',
    description: 'The same number grouped for reading. Show this, send `phone`.',
  })
  displayPhone: string;

  @ApiProperty({ example: 300 })
  expiresInSeconds: number;

  @ApiProperty({ example: 60, description: 'How long to wait before asking for another code.' })
  resendAfterSeconds: number;
}

export class VerifyOtpDto extends RequestOtpDto {
  @ApiProperty({ example: '482913', pattern: CODE_PATTERN.source })
  @IsString()
  @Matches(CODE_PATTERN, { message: 'Enter the 6-digit code.' })
  code: string;

  @ApiPropertyOptional({ example: 'Tecno Spark 10', maxLength: 80 })
  @IsOptional()
  @CleanText()
  @IsString()
  @MaxLength(80)
  deviceName?: string;
}

export class TokenPairDto {
  @ApiProperty({ description: 'Send as `Authorization: Bearer <token>`.' })
  accessToken: string;

  @ApiProperty({ description: 'Single use. Each refresh returns a new one.' })
  refreshToken: string;

  @ApiProperty({ example: 900, description: 'Access token lifetime in seconds.' })
  accessTokenExpiresIn: number;
}

export class AuthSessionDto {
  @ApiProperty({ type: () => TokenPairDto })
  tokens: TokenPairDto;

  @ApiProperty({ description: 'True when this sign-in created the account.' })
  isNewUser: boolean;

  @ApiProperty({ type: () => MeDto })
  me: MeDto;
}

export class RefreshTokenDto {
  @ApiProperty()
  @IsString()
  @Length(40, 200)
  refreshToken: string;
}
