import {
  Controller,
  Get,
  HttpCode,
  HttpStatus,
  Injectable,
  Module,
  Post,
  Query,
} from '@nestjs/common';
import {
  ApiBearerAuth,
  ApiDefaultResponse,
  ApiNoContentResponse,
  ApiOkResponse,
  ApiOperation,
  ApiProperty,
  ApiTags,
} from '@nestjs/swagger';

import { ProblemDto } from '../../common/errors/problem.dto.js';
import { CursorQueryDto, DEFAULT_PAGE_SIZE } from '../../common/pagination/cursor.js';
import { CurrentUser, type AuthUser } from '../auth/index.js';
import { NotificationsModule } from '../notifications/notifications.module.js';
import { NotificationsService } from '../notifications/notifications.service.js';
import {
  APPLICATION_STATUSES,
  type ApplicationStatus,
} from '../opportunities/dto/opportunity.dto.js';
import { OpportunitiesModule } from '../opportunities/opportunities.module.js';
import { OpportunitiesService } from '../opportunities/opportunities.service.js';
import { PostsModule } from '../posts/posts.module.js';
import { PostsService } from '../posts/posts.service.js';
import { PersonSummaryDto } from '../profiles/dto/person.dto.js';
import { PeopleService } from '../profiles/people.service.js';
import { ProfilesModule } from '../profiles/profiles.module.js';

export const NOTIFICATION_TYPES = [
  'application_received',
  'application_status',
  'new_follower',
  'post_liked',
  'post_commented',
] as const;

export class NotificationDto {
  @ApiProperty({ format: 'uuid' })
  id: string;

  @ApiProperty({ enum: NOTIFICATION_TYPES, enumName: 'NotificationType' })
  type: (typeof NOTIFICATION_TYPES)[number];

  @ApiProperty({ type: () => PersonSummaryDto, nullable: true })
  actor: PersonSummaryDto | null;

  @ApiProperty({ type: String, nullable: true, format: 'uuid' })
  opportunityId: string | null;

  @ApiProperty({ type: String, nullable: true })
  opportunityTitle: string | null;

  @ApiProperty({
    enum: APPLICATION_STATUSES,
    enumName: 'ApplicationStatus',
    nullable: true,
    description: 'The application’s current status, for status notifications.',
  })
  applicationStatus: ApplicationStatus | null;

  @ApiProperty({ type: String, nullable: true, format: 'uuid' })
  postId: string | null;

  @ApiProperty({
    type: String,
    nullable: true,
    description: 'The start of the post, or of the comment for comment notices.',
  })
  snippet: string | null;

  @ApiProperty()
  isRead: boolean;

  @ApiProperty()
  createdAt: Date;
}

export class NotificationPageDto {
  @ApiProperty({ type: () => [NotificationDto] })
  items: NotificationDto[];

  @ApiProperty({ type: String, nullable: true })
  nextCursor: string | null;
}

export class UnreadCountDto {
  @ApiProperty()
  count: number;
}

/** Turns stored notification references into what a screen can show. */
@Injectable()
export class ActivityService {
  constructor(
    private readonly notifications: NotificationsService,
    private readonly people: PeopleService,
    private readonly opportunities: OpportunitiesService,
    private readonly posts: PostsService,
  ) {}

  async list(userId: string, query: CursorQueryDto): Promise<NotificationPageDto> {
    const page = await this.notifications.list(
      userId,
      query.cursor,
      query.limit ?? DEFAULT_PAGE_SIZE,
    );
    const [people, titles, statuses, snippets] = await Promise.all([
      this.people.summaries(page.items.flatMap((n) => (n.actorId ? [n.actorId] : []))),
      this.opportunities.titles(
        page.items.flatMap((n) => (n.opportunityId ? [n.opportunityId] : [])),
      ),
      this.opportunities.applicationStatuses(
        page.items.flatMap((n) => (n.applicationId ? [n.applicationId] : [])),
      ),
      this.posts.snippets(
        page.items.flatMap((n) => (n.postId ? [n.postId] : [])),
        page.items.flatMap((n) => (n.commentId ? [n.commentId] : [])),
      ),
    ]);
    return {
      items: page.items.map((n) => ({
        id: n.id,
        type: n.type,
        actor: n.actorId ? (people.get(n.actorId) ?? null) : null,
        opportunityId: n.opportunityId,
        opportunityTitle: n.opportunityId ? (titles.get(n.opportunityId) ?? null) : null,
        applicationStatus: n.applicationId ? (statuses.get(n.applicationId) ?? null) : null,
        postId: n.postId,
        snippet: n.commentId
          ? (snippets.comments.get(n.commentId) ?? null)
          : n.postId
            ? (snippets.posts.get(n.postId) ?? null)
            : null,
        isRead: n.readAt !== null,
        createdAt: n.createdAt,
      })),
      nextCursor: page.nextCursor,
    };
  }
}

@ApiTags('activity')
@ApiBearerAuth()
@ApiDefaultResponse({ type: ProblemDto })
@Controller('me/notifications')
export class ActivityController {
  constructor(
    private readonly activity: ActivityService,
    private readonly notifications: NotificationsService,
  ) {}

  @Get()
  @ApiOperation({ summary: 'My notifications, newest first' })
  @ApiOkResponse({ type: NotificationPageDto })
  listNotifications(
    @CurrentUser() user: AuthUser,
    @Query() query: CursorQueryDto,
  ): Promise<NotificationPageDto> {
    return this.activity.list(user.id, query);
  }

  @Get('unread-count')
  @ApiOperation({ summary: 'How many notifications I have not seen' })
  @ApiOkResponse({ type: UnreadCountDto })
  async getUnreadCount(@CurrentUser() user: AuthUser): Promise<UnreadCountDto> {
    return { count: await this.notifications.unreadCount(user.id) };
  }

  @Post('read-all')
  @HttpCode(HttpStatus.NO_CONTENT)
  @ApiOperation({ summary: 'Mark all my notifications as seen' })
  @ApiNoContentResponse()
  markAllRead(@CurrentUser() user: AuthUser): Promise<void> {
    return this.notifications.markAllRead(user.id);
  }
}

@Module({
  imports: [NotificationsModule, ProfilesModule, OpportunitiesModule, PostsModule],
  controllers: [ActivityController],
  providers: [ActivityService],
})
export class ActivityModule {}
