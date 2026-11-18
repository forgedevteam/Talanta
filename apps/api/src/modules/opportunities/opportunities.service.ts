import { HttpStatus, Inject, Injectable, Logger } from '@nestjs/common';
import {
  and,
  desc,
  eq,
  gt,
  gte,
  ilike,
  inArray,
  isNull,
  lt,
  ne,
  or,
  sql,
  type SQL,
} from 'drizzle-orm';

import { CLOCK, type Clock } from '../../common/clock/clock.js';
import { AppError } from '../../common/errors/app-error.js';
import { DEFAULT_PAGE_SIZE, toPage } from '../../common/pagination/cursor.js';
import { RateLimiter } from '../../common/rate-limit/rate-limiter.js';
import { DATABASE, isUniqueViolation, type Database } from '../../database/database.js';
import {
  applications,
  opportunities,
  type Application,
  type Opportunity,
} from '../../database/schema/index.js';
import { AccountService } from '../account/account.service.js';
import { NotificationsService } from '../notifications/notifications.service.js';
import { PortfolioService } from '../portfolio/portfolio.service.js';
import { PeopleService } from '../profiles/people.service.js';
import { likeLiteral } from '../profiles/profiles.service.js';
import { TalentsService } from '../talents/talents.service.js';
import type {
  ApplicantDto,
  ApplyDto,
  CreateOpportunityDto,
  MyApplicationDto,
  OpportunityDetailDto,
  OpportunityFeedDto,
  OpportunityQueryDto,
  OpportunitySummaryDto,
} from './dto/opportunity.dto.js';

const DAY_SECONDS = 86_400;
const MAX_FEATURED = 5;
const MAX_DEADLINE_DAYS = 366;

const notFound = (): AppError =>
  new AppError(HttpStatus.NOT_FOUND, 'not_found', 'That call is no longer available.');

const isoDay = (date: Date): string => date.toISOString().slice(0, 10);

@Injectable()
export class OpportunitiesService {
  private readonly logger = new Logger(OpportunitiesService.name);

  constructor(
    @Inject(DATABASE) private readonly db: Database,
    @Inject(CLOCK) private readonly clock: Clock,
    private readonly rateLimiter: RateLimiter,
    private readonly account: AccountService,
    private readonly people: PeopleService,
    private readonly talents: TalentsService,
    private readonly portfolio: PortfolioService,
    private readonly notifications: NotificationsService,
  ) {}

  // ---------------------------------------------------------------- reading

  async feed(query: OpportunityQueryDto): Promise<OpportunityFeedDto> {
    const limit = query.limit ?? DEFAULT_PAGE_SIZE;
    const now = this.clock.now();
    const filters: SQL[] = [
      eq(opportunities.status, 'open'),
      or(isNull(opportunities.deadline), gte(opportunities.deadline, isoDay(now))) ?? sql`true`,
    ];
    if (query.category) {
      const category = await this.talents.findBySlug(query.category);
      if (!category) return { featured: [], items: [], nextCursor: null };
      filters.push(eq(opportunities.categoryId, category.id));
    }
    if (query.city) filters.push(ilike(opportunities.city, likeLiteral(query.city)));

    const isFeatured = gt(opportunities.featuredUntil, now);
    const [featuredRows, rows] = await Promise.all([
      query.cursor
        ? Promise.resolve([])
        : this.db
            .select()
            .from(opportunities)
            .where(and(...filters, isFeatured))
            .orderBy(desc(opportunities.featuredUntil))
            .limit(MAX_FEATURED),
      this.db
        .select()
        .from(opportunities)
        .where(
          and(
            ...filters,
            // Featured calls have their own row; keep them out of the list.
            or(isNull(opportunities.featuredUntil), lt(opportunities.featuredUntil, now)),
            query.cursor ? lt(opportunities.id, query.cursor) : undefined,
          ),
        )
        .orderBy(desc(opportunities.id))
        .limit(limit + 1),
    ]);

    const page = toPage(rows, limit);
    const summaries = await this.summarise([...featuredRows, ...page.items]);
    return {
      featured: summaries.slice(0, featuredRows.length),
      items: summaries.slice(featuredRows.length),
      nextCursor: page.nextCursor,
    };
  }

  async detail(id: string, viewerId: string): Promise<OpportunityDetailDto> {
    const row = await this.find(id);
    if (!row || (row.status === 'removed' && row.posterId !== viewerId)) throw notFound();

    const [[summary], mine] = await Promise.all([
      this.summarise([row]),
      this.db
        .select({ id: applications.id, status: applications.status })
        .from(applications)
        .where(and(eq(applications.opportunityId, id), eq(applications.applicantId, viewerId)))
        .limit(1),
    ]);
    if (!summary) throw notFound();
    return {
      ...summary,
      description: row.description,
      isMine: row.posterId === viewerId,
      myApplication: mine[0] ?? null,
    };
  }

  async listMine(posterId: string): Promise<OpportunitySummaryDto[]> {
    const rows = await this.db
      .select()
      .from(opportunities)
      .where(and(eq(opportunities.posterId, posterId), ne(opportunities.status, 'removed')))
      .orderBy(desc(opportunities.id))
      .limit(100);
    return this.summarise(rows);
  }

  async listMyApplications(applicantId: string): Promise<MyApplicationDto[]> {
    const rows = await this.db
      .select()
      .from(applications)
      .where(eq(applications.applicantId, applicantId))
      .orderBy(desc(applications.id))
      .limit(100);
    if (rows.length === 0) return [];
    const opportunityRows = await this.db
      .select()
      .from(opportunities)
      .where(
        inArray(
          opportunities.id,
          rows.map((row) => row.opportunityId),
        ),
      );
    const summaries = new Map(
      (await this.summarise(opportunityRows)).map((summary) => [summary.id, summary]),
    );
    return rows.flatMap((row) => {
      const opportunity = summaries.get(row.opportunityId);
      return opportunity
        ? [{ applicationId: row.id, status: row.status, createdAt: row.createdAt, opportunity }]
        : [];
    });
  }

  /** Only the poster sees who applied. Anyone else gets the same answer as a missing call. */
  async listApplicants(opportunityId: string, viewerId: string): Promise<ApplicantDto[]> {
    const row = await this.find(opportunityId);
    if (row?.posterId !== viewerId) throw notFound();

    const rows = await this.db
      .select()
      .from(applications)
      .where(eq(applications.opportunityId, opportunityId))
      .orderBy(desc(applications.id))
      .limit(200);
    const [people, items] = await Promise.all([
      this.people.summaries(rows.map((r) => r.applicantId)),
      this.portfolio.findByIds(rows.flatMap((r) => (r.portfolioItemId ? [r.portfolioItemId] : []))),
    ]);
    const itemsById = new Map(items.map((item) => [item.id, item]));
    return rows.flatMap((r) => {
      const applicant = people.get(r.applicantId);
      if (!applicant) return [];
      return [
        {
          applicationId: r.id,
          status: r.status,
          message: r.message,
          createdAt: r.createdAt,
          applicant,
          portfolioItem: r.portfolioItemId ? (itemsById.get(r.portfolioItemId) ?? null) : null,
        },
      ];
    });
  }

  // ---------------------------------------------------------------- writing

  async create(posterId: string, input: CreateOpportunityDto): Promise<OpportunityDetailDto> {
    const { country } = await this.account.assertCanUseOpenCalls(posterId);
    await this.consume(`opportunity:create:${posterId}`, 5, DAY_SECONDS);

    if (!(await this.talents.categoryExists(input.categoryId))) {
      throw new AppError(
        HttpStatus.UNPROCESSABLE_ENTITY,
        'talent_category_unknown',
        'That talent is not on the list.',
      );
    }
    if (input.deadline) this.checkDeadline(input.deadline);

    const [row] = await this.db
      .insert(opportunities)
      .values({
        posterId,
        title: input.title,
        description: input.description.trim(),
        categoryId: input.categoryId,
        city: input.city,
        country: country ?? 'CM',
        compensation: input.compensation,
        budgetAmount: input.compensation === 'unpaid' ? null : (input.budgetAmount ?? null),
        deadline: input.deadline ?? null,
      })
      .returning();
    if (!row) throw new Error('Opportunity insert returned no row');
    return this.detail(row.id, posterId);
  }

  async close(opportunityId: string, viewerId: string): Promise<OpportunityDetailDto> {
    const row = await this.find(opportunityId);
    if (row?.posterId !== viewerId || row.status === 'removed') throw notFound();
    await this.db
      .update(opportunities)
      .set({ status: 'closed' })
      .where(eq(opportunities.id, opportunityId));
    return this.detail(opportunityId, viewerId);
  }

  async apply(
    opportunityId: string,
    applicantId: string,
    input: ApplyDto,
  ): Promise<OpportunityDetailDto> {
    const row = await this.find(opportunityId);
    if (!row || row.status === 'removed') throw notFound();
    if (row.posterId === applicantId) {
      throw new AppError(
        HttpStatus.UNPROCESSABLE_ENTITY,
        'cannot_apply_to_own',
        'You cannot apply to your own call.',
      );
    }
    if (row.status !== 'open' || (row.deadline && row.deadline < isoDay(this.clock.now()))) {
      throw new AppError(HttpStatus.CONFLICT, 'opportunity_closed', 'This call is closed.');
    }
    await this.account.assertCanUseOpenCalls(applicantId);
    if (
      input.portfolioItemId &&
      !(await this.portfolio.findOwned(applicantId, input.portfolioItemId))
    ) {
      throw new AppError(
        HttpStatus.UNPROCESSABLE_ENTITY,
        'validation_failed',
        'Pick a piece from your own portfolio.',
        {
          fields: { portfolioItemId: ['Pick a piece from your own portfolio.'] },
        },
      );
    }
    await this.consume(`opportunity:apply:${applicantId}`, 30, DAY_SECONDS);

    let application: Application;
    try {
      application = await this.db.transaction(async (tx) => {
        const [inserted] = await tx
          .insert(applications)
          .values({
            opportunityId,
            applicantId,
            message: input.message.trim(),
            portfolioItemId: input.portfolioItemId ?? null,
          })
          .returning();
        if (!inserted) throw new Error('Application insert returned no row');
        await tx
          .update(opportunities)
          .set({ applicationsCount: sql`${opportunities.applicationsCount} + 1` })
          .where(eq(opportunities.id, opportunityId));
        return inserted;
      });
    } catch (error) {
      if (isUniqueViolation(error)) {
        throw new AppError(HttpStatus.CONFLICT, 'already_applied', 'You have already applied.');
      }
      throw error;
    }

    await this.notifySafely({
      userId: row.posterId,
      type: 'application_received',
      actorId: applicantId,
      opportunityId,
      applicationId: application.id,
    });
    return this.detail(opportunityId, applicantId);
  }

  async decide(
    applicationId: string,
    viewerId: string,
    status: 'shortlisted' | 'declined' | 'hired',
  ): Promise<ApplicantDto> {
    const [found] = await this.db
      .select({ application: applications, posterId: opportunities.posterId })
      .from(applications)
      .innerJoin(opportunities, eq(applications.opportunityId, opportunities.id))
      .where(eq(applications.id, applicationId))
      .limit(1);
    if (found?.posterId !== viewerId) {
      throw new AppError(HttpStatus.NOT_FOUND, 'not_found', 'That application is not available.');
    }

    if (found.application.status !== status) {
      await this.db.update(applications).set({ status }).where(eq(applications.id, applicationId));
      await this.notifySafely({
        userId: found.application.applicantId,
        type: 'application_status',
        actorId: viewerId,
        opportunityId: found.application.opportunityId,
        applicationId,
      });
    }

    const applicants = await this.listApplicants(found.application.opportunityId, viewerId);
    const updated = applicants.find((applicant) => applicant.applicationId === applicationId);
    if (!updated)
      throw new AppError(HttpStatus.NOT_FOUND, 'not_found', 'That application is not available.');
    return updated;
  }

  // ---------------------------------------------------------------- admin and lifecycle

  async feature(opportunityId: string, days: number): Promise<OpportunityDetailDto> {
    const row = await this.find(opportunityId);
    if (!row) throw notFound();
    const until = new Date(this.clock.now().getTime() + days * DAY_SECONDS * 1000);
    await this.db
      .update(opportunities)
      .set({ featuredUntil: until })
      .where(eq(opportunities.id, opportunityId));
    return this.detail(opportunityId, row.posterId);
  }

  async remove(opportunityId: string): Promise<void> {
    const updated = await this.db
      .update(opportunities)
      .set({ status: 'removed', featuredUntil: null })
      .where(eq(opportunities.id, opportunityId))
      .returning({ id: opportunities.id });
    if (updated.length === 0) throw notFound();
  }

  async removeAllForPoster(posterId: string): Promise<void> {
    await this.db
      .update(opportunities)
      .set({ status: 'removed', featuredUntil: null })
      .where(eq(opportunities.posterId, posterId));
  }

  async exists(opportunityId: string): Promise<boolean> {
    return (await this.find(opportunityId)) !== null;
  }

  async titles(ids: readonly string[]): Promise<Map<string, string>> {
    if (ids.length === 0) return new Map();
    const rows = await this.db
      .select({ id: opportunities.id, title: opportunities.title })
      .from(opportunities)
      .where(inArray(opportunities.id, [...ids]));
    return new Map(rows.map((row) => [row.id, row.title]));
  }

  async applicationStatuses(ids: readonly string[]): Promise<Map<string, Application['status']>> {
    if (ids.length === 0) return new Map();
    const rows = await this.db
      .select({ id: applications.id, status: applications.status })
      .from(applications)
      .where(inArray(applications.id, [...ids]));
    return new Map(rows.map((row) => [row.id, row.status]));
  }

  // ---------------------------------------------------------------- helpers

  private async find(id: string): Promise<Opportunity | null> {
    const [row] = await this.db
      .select()
      .from(opportunities)
      .where(eq(opportunities.id, id))
      .limit(1);
    return row ?? null;
  }

  private async summarise(rows: readonly Opportunity[]): Promise<OpportunitySummaryDto[]> {
    if (rows.length === 0) return [];
    const now = this.clock.now();
    const [people, categories] = await Promise.all([
      this.people.summaries(rows.map((row) => row.posterId)),
      this.talents.categoriesById(),
    ]);
    return rows.flatMap((row) => {
      const category = categories.get(row.categoryId);
      if (!category) return [];
      return [
        {
          id: row.id,
          title: row.title,
          category,
          city: row.city,
          country: row.country,
          compensation: row.compensation,
          budgetAmount: row.budgetAmount,
          currency: row.currency,
          deadline: row.deadline,
          status: row.status,
          isFeatured: row.featuredUntil !== null && row.featuredUntil > now,
          applicationsCount: row.applicationsCount,
          poster: people.get(row.posterId) ?? null,
          createdAt: row.createdAt,
        },
      ];
    });
  }

  private checkDeadline(deadline: string): void {
    const today = this.clock.now();
    const latest = new Date(today.getTime() + MAX_DEADLINE_DAYS * DAY_SECONDS * 1000);
    if (deadline < isoDay(today) || deadline > isoDay(latest)) {
      throw new AppError(
        HttpStatus.UNPROCESSABLE_ENTITY,
        'validation_failed',
        'Choose a closing date in the next year.',
        {
          fields: { deadline: ['Choose a closing date in the next year.'] },
        },
      );
    }
  }

  private async consume(key: string, limit: number, windowSeconds: number): Promise<void> {
    const result = await this.rateLimiter.consume(key, { limit, windowSeconds });
    if (!result.allowed) {
      throw new AppError(
        HttpStatus.TOO_MANY_REQUESTS,
        'rate_limited',
        'You have reached today’s limit. Try again tomorrow.',
        {
          retryAfterSeconds: result.retryAfterSeconds,
        },
      );
    }
  }

  /** A failed notification must never undo the action that caused it. */
  private async notifySafely(input: Parameters<NotificationsService['notify']>[0]): Promise<void> {
    try {
      await this.notifications.notify(input);
    } catch (error) {
      this.logger.error(
        'Notification failed',
        error instanceof Error ? error.stack : String(error),
      );
    }
  }
}
