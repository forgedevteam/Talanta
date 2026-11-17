import { HttpStatus, Inject, Injectable } from '@nestjs/common';

import { AppError } from '../../common/errors/app-error.js';
import { APP_CONFIG } from '../../config/config.module.js';
import type { AppConfig } from '../../config/env.js';
import { AccountService } from '../account/account.service.js';
import { UsersService } from '../users/users.service.js';
import type {
  AuthSessionDto,
  OtpChallengeDto,
  RequestOtpDto,
  TokenPairDto,
  VerifyOtpDto,
} from './dto/auth.dto.js';
import { OtpService } from './otp/otp.service.js';
import { parsePhoneNumber } from './phone/phone-number.js';
import { SessionService } from './sessions/session.service.js';

/** The sign-in use cases, start to finish. */
@Injectable()
export class AuthService {
  constructor(
    @Inject(APP_CONFIG) private readonly config: AppConfig,
    private readonly otp: OtpService,
    private readonly sessions: SessionService,
    private readonly users: UsersService,
    private readonly account: AccountService,
  ) {}

  async requestOtp(input: RequestOtpDto, ip: string): Promise<OtpChallengeDto> {
    const phone = parsePhoneNumber(input.phone, input.country, this.config.sms.allowedCountries);
    const challenge = await this.otp.request(phone.e164, ip);
    return { phone: phone.e164, ...challenge };
  }

  async verifyOtp(input: VerifyOtpDto): Promise<AuthSessionDto> {
    const phone = parsePhoneNumber(input.phone, input.country, this.config.sms.allowedCountries);
    await this.otp.verify(phone.e164, input.code);

    const { user, created } = await this.users.findOrCreateByPhone(phone.e164, phone.country);
    if (user.status !== 'active') {
      throw new AppError(HttpStatus.FORBIDDEN, 'account_suspended', 'This account is not active.');
    }

    const tokens = await this.sessions.start(user, input.deviceName ?? null);
    return { tokens, isNewUser: created, me: await this.account.getMe(user.id) };
  }

  refresh(refreshToken: string): Promise<TokenPairDto> {
    return this.sessions.rotate(refreshToken);
  }

  signOut(refreshToken: string): Promise<void> {
    return this.sessions.end(refreshToken);
  }
}
