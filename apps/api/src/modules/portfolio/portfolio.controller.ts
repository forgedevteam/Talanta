import {
  Body,
  Controller,
  Delete,
  Get,
  HttpCode,
  HttpStatus,
  Param,
  ParseUUIDPipe,
  Post,
} from '@nestjs/common';
import {
  ApiBearerAuth,
  ApiDefaultResponse,
  ApiNoContentResponse,
  ApiOkResponse,
  ApiOperation,
  ApiTags,
} from '@nestjs/swagger';

import { ProblemDto } from '../../common/errors/problem.dto.js';
import { CurrentUser, type AuthUser } from '../auth/index.js';
import { CreatePortfolioItemDto, PortfolioItemDto } from './dto/portfolio.dto.js';
import { PortfolioService } from './portfolio.service.js';

@ApiTags('portfolio')
@ApiBearerAuth()
@ApiDefaultResponse({ type: ProblemDto })
@Controller('me/portfolio')
export class PortfolioController {
  constructor(private readonly portfolio: PortfolioService) {}

  @Get()
  @ApiOperation({ summary: 'My portfolio, newest first' })
  @ApiOkResponse({ type: [PortfolioItemDto] })
  listMyPortfolio(@CurrentUser() user: AuthUser): Promise<PortfolioItemDto[]> {
    return this.portfolio.listForUser(user.id);
  }

  @Post()
  @ApiOperation({ summary: 'Add a link to a piece of my work' })
  @ApiOkResponse({ type: PortfolioItemDto })
  addPortfolioItem(
    @CurrentUser() user: AuthUser,
    @Body() body: CreatePortfolioItemDto,
  ): Promise<PortfolioItemDto> {
    return this.portfolio.create(user.id, body);
  }

  @Delete(':id')
  @HttpCode(HttpStatus.NO_CONTENT)
  @ApiOperation({ summary: 'Remove a piece from my portfolio' })
  @ApiNoContentResponse()
  removePortfolioItem(
    @CurrentUser() user: AuthUser,
    @Param('id', new ParseUUIDPipe()) id: string,
  ): Promise<void> {
    return this.portfolio.delete(user.id, id);
  }
}
