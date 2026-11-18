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
  Query,
} from '@nestjs/common';
import {
  ApiBearerAuth,
  ApiCreatedResponse,
  ApiDefaultResponse,
  ApiNoContentResponse,
  ApiOkResponse,
  ApiOperation,
  ApiTags,
} from '@nestjs/swagger';

import { ProblemDto } from '../../common/errors/problem.dto.js';
import { CursorQueryDto } from '../../common/pagination/cursor.js';
import { CurrentUser, type AuthUser } from '../auth/index.js';
import { UsernameQueryDto } from '../profiles/dto/profile.dto.js';
import {
  CommentDto,
  CommentPageDto,
  CreateCommentDto,
  CreatePostDto,
  CreatorPostsQueryDto,
  FeedQueryDto,
  LikeStateDto,
  PostDto,
  PostPageDto,
  ShareDto,
} from './dto/post.dto.js';
import { PostsService } from './posts.service.js';

const postId = new ParseUUIDPipe();

@ApiTags('posts')
@ApiBearerAuth()
@ApiDefaultResponse({ type: ProblemDto })
@Controller()
export class PostsController {
  constructor(private readonly posts: PostsService) {}

  @Get('feed')
  @ApiOperation({ summary: 'The home feed: everyone, or the people I follow' })
  @ApiOkResponse({ type: PostPageDto })
  getFeed(@CurrentUser() user: AuthUser, @Query() query: FeedQueryDto): Promise<PostPageDto> {
    return this.posts.feed(user.id, query);
  }

  @Get('reels')
  @ApiOperation({ summary: 'Short vertical videos, newest first' })
  @ApiOkResponse({ type: PostPageDto })
  getReels(@CurrentUser() user: AuthUser, @Query() query: CursorQueryDto): Promise<PostPageDto> {
    return this.posts.reels(user.id, query);
  }

  @Get('creators/:username/posts')
  @ApiOperation({ summary: 'A creator’s posts, or only their reels' })
  @ApiOkResponse({ type: PostPageDto })
  getCreatorPosts(
    @CurrentUser() user: AuthUser,
    @Param() params: UsernameQueryDto,
    @Query() query: CreatorPostsQueryDto,
  ): Promise<PostPageDto> {
    return this.posts.byCreator(user.id, params.username, query);
  }

  @Post('posts')
  @ApiOperation({ summary: 'Share words, photos or a video' })
  @ApiCreatedResponse({ type: PostDto })
  createPost(@CurrentUser() user: AuthUser, @Body() body: CreatePostDto): Promise<PostDto> {
    return this.posts.create(user.id, body);
  }

  @Get('posts/:id')
  @ApiOperation({ summary: 'One post' })
  @ApiOkResponse({ type: PostDto })
  getPost(@CurrentUser() user: AuthUser, @Param('id', postId) id: string): Promise<PostDto> {
    return this.posts.get(user.id, id);
  }

  @Delete('posts/:id')
  @HttpCode(HttpStatus.NO_CONTENT)
  @ApiOperation({ summary: 'Delete my post' })
  @ApiNoContentResponse()
  deletePost(@CurrentUser() user: AuthUser, @Param('id', postId) id: string): Promise<void> {
    return this.posts.delete(user.id, id);
  }

  @Post('posts/:id/like')
  @HttpCode(HttpStatus.OK)
  @ApiOperation({ summary: 'Like a post' })
  @ApiOkResponse({ type: LikeStateDto })
  likePost(@CurrentUser() user: AuthUser, @Param('id', postId) id: string): Promise<LikeStateDto> {
    return this.posts.like(user.id, id);
  }

  @Delete('posts/:id/like')
  @ApiOperation({ summary: 'Take back my like' })
  @ApiOkResponse({ type: LikeStateDto })
  unlikePost(
    @CurrentUser() user: AuthUser,
    @Param('id', postId) id: string,
  ): Promise<LikeStateDto> {
    return this.posts.unlike(user.id, id);
  }

  @Post('posts/:id/share')
  @HttpCode(HttpStatus.OK)
  @ApiOperation({ summary: 'Get a link to share, and count the share' })
  @ApiOkResponse({ type: ShareDto })
  sharePost(@CurrentUser() user: AuthUser, @Param('id', postId) id: string): Promise<ShareDto> {
    return this.posts.share(user.id, id);
  }

  @Get('posts/:id/comments')
  @ApiOperation({ summary: 'Comments on a post, oldest first' })
  @ApiOkResponse({ type: CommentPageDto })
  listComments(
    @CurrentUser() user: AuthUser,
    @Param('id', postId) id: string,
    @Query() query: CursorQueryDto,
  ): Promise<CommentPageDto> {
    return this.posts.comments(user.id, id, query);
  }

  @Post('posts/:id/comments')
  @ApiOperation({ summary: 'Comment on a post' })
  @ApiCreatedResponse({ type: CommentDto })
  addComment(
    @CurrentUser() user: AuthUser,
    @Param('id', postId) id: string,
    @Body() body: CreateCommentDto,
  ): Promise<CommentDto> {
    return this.posts.addComment(user.id, id, body);
  }

  @Delete('comments/:id')
  @HttpCode(HttpStatus.NO_CONTENT)
  @ApiOperation({ summary: 'Delete a comment I wrote, or one on my post' })
  @ApiNoContentResponse()
  deleteComment(@CurrentUser() user: AuthUser, @Param('id', postId) id: string): Promise<void> {
    return this.posts.deleteComment(user.id, id);
  }
}
