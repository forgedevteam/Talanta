import {
  Body,
  Controller,
  Get,
  HttpCode,
  HttpStatus,
  Param,
  ParseUUIDPipe,
  Patch,
  Post,
  Query,
} from '@nestjs/common';
import {
  ApiBearerAuth,
  ApiDefaultResponse,
  ApiOkResponse,
  ApiOperation,
  ApiTags,
} from '@nestjs/swagger';

import { ProblemDto } from '../../common/errors/problem.dto.js';
import { CurrentUser, type AuthUser } from '../auth/index.js';
import {
  ApplicantDto,
  ApplyDto,
  CreateOpportunityDto,
  DecideApplicationDto,
  MyApplicationDto,
  OpportunityDetailDto,
  OpportunityFeedDto,
  OpportunityQueryDto,
  OpportunitySummaryDto,
} from './dto/opportunity.dto.js';
import { OpportunitiesService } from './opportunities.service.js';

const uuid = new ParseUUIDPipe();

@ApiTags('opportunities')
@ApiBearerAuth()
@ApiDefaultResponse({ type: ProblemDto })
@Controller()
export class OpportunitiesController {
  constructor(private readonly opportunities: OpportunitiesService) {}

  @Get('opportunities')
  @ApiOperation({ summary: 'Open Calls, newest first, with featured calls on the first page' })
  @ApiOkResponse({ type: OpportunityFeedDto })
  listOpportunities(@Query() query: OpportunityQueryDto): Promise<OpportunityFeedDto> {
    return this.opportunities.feed(query);
  }

  @Post('opportunities')
  @ApiOperation({ summary: 'Post an Open Call' })
  @ApiOkResponse({ type: OpportunityDetailDto })
  postOpportunity(
    @CurrentUser() user: AuthUser,
    @Body() body: CreateOpportunityDto,
  ): Promise<OpportunityDetailDto> {
    return this.opportunities.create(user.id, body);
  }

  @Get('opportunities/:id')
  @ApiOperation({ summary: 'One Open Call, with my application if I applied' })
  @ApiOkResponse({ type: OpportunityDetailDto })
  getOpportunity(
    @CurrentUser() user: AuthUser,
    @Param('id', uuid) id: string,
  ): Promise<OpportunityDetailDto> {
    return this.opportunities.detail(id, user.id);
  }

  @Post('opportunities/:id/close')
  @HttpCode(HttpStatus.OK)
  @ApiOperation({ summary: 'Stop taking applications for my call' })
  @ApiOkResponse({ type: OpportunityDetailDto })
  closeOpportunity(
    @CurrentUser() user: AuthUser,
    @Param('id', uuid) id: string,
  ): Promise<OpportunityDetailDto> {
    return this.opportunities.close(id, user.id);
  }

  @Post('opportunities/:id/applications')
  @ApiOperation({ summary: 'Apply to an Open Call' })
  @ApiOkResponse({ type: OpportunityDetailDto })
  applyToOpportunity(
    @CurrentUser() user: AuthUser,
    @Param('id', uuid) id: string,
    @Body() body: ApplyDto,
  ): Promise<OpportunityDetailDto> {
    return this.opportunities.apply(id, user.id, body);
  }

  @Get('opportunities/:id/applications')
  @ApiOperation({ summary: 'People who applied to my call' })
  @ApiOkResponse({ type: [ApplicantDto] })
  listApplicants(
    @CurrentUser() user: AuthUser,
    @Param('id', uuid) id: string,
  ): Promise<ApplicantDto[]> {
    return this.opportunities.listApplicants(id, user.id);
  }

  @Patch('applications/:id')
  @ApiOperation({ summary: 'Shortlist, decline or hire an applicant to my call' })
  @ApiOkResponse({ type: ApplicantDto })
  decideApplication(
    @CurrentUser() user: AuthUser,
    @Param('id', uuid) id: string,
    @Body() body: DecideApplicationDto,
  ): Promise<ApplicantDto> {
    return this.opportunities.decide(id, user.id, body.status);
  }

  @Get('me/opportunities')
  @ApiOperation({ summary: 'Calls I posted' })
  @ApiOkResponse({ type: [OpportunitySummaryDto] })
  listMyOpportunities(@CurrentUser() user: AuthUser): Promise<OpportunitySummaryDto[]> {
    return this.opportunities.listMine(user.id);
  }

  @Get('me/applications')
  @ApiOperation({ summary: 'Calls I applied to, with where each one stands' })
  @ApiOkResponse({ type: [MyApplicationDto] })
  listMyApplications(@CurrentUser() user: AuthUser): Promise<MyApplicationDto[]> {
    return this.opportunities.listMyApplications(user.id);
  }
}
