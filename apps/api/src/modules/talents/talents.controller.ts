import { Controller, Get, Header } from '@nestjs/common';
import { ApiDefaultResponse, ApiOkResponse, ApiOperation, ApiTags } from '@nestjs/swagger';

import { ProblemDto } from '../../common/errors/problem.dto.js';
import { Public } from '../auth/index.js';
import { TalentCategoryDto } from './dto/talent.dto.js';
import { TalentsService } from './talents.service.js';

@ApiTags('talents')
@ApiDefaultResponse({ type: ProblemDto })
@Controller('talent-categories')
export class TalentsController {
  constructor(private readonly talents: TalentsService) {}

  @Public()
  @Get()
  // The list changes a few times a year, so let phones and the CDN hold on to it.
  @Header('Cache-Control', 'public, max-age=300, stale-while-revalidate=86400')
  @ApiOperation({ summary: 'List the talent categories people can pick from' })
  @ApiOkResponse({ type: [TalentCategoryDto] })
  async listTalentCategories(): Promise<TalentCategoryDto[]> {
    const categories = await this.talents.listCategories();
    return categories.map(({ id, slug, name, icon }) => ({ id, slug, name, icon }));
  }
}
