import {
  Controller,
  Get,
  Post,
  Body,
  Param,
  Delete,
  Query,
  Put,
  BadRequestException,
  UseGuards,
  Req,
} from '@nestjs/common';
import { PostingsService } from './postings.service';
import { CreatePostingDto } from './dto/create-posting.dto';
import { UpdatePostingDto } from './dto/update-posting.dto';
import { SearchPostingDto } from './dto/search-posting.dto';
import {
  ApiCreatedResponse,
  ApiOkResponse,
  ApiOperation,
  ApiTags,
} from '@nestjs/swagger';
import { Posting } from './entities/posting.entity';
import {
  budgets,
  headcounts,
  locations,
  periods,
  seasons,
  themes,
  vehicles,
  withWhos,
} from './postings.types';
import { AuthGuard } from '../auth/auth.guard';

@UseGuards(AuthGuard)
@Controller('postings')
@ApiTags('Postings API')
export class PostingsController {
  constructor(private readonly postingsService: PostingsService) {}

  @Post()
  @ApiOperation({
    summary: '포스팅 생성 API',
    description: '새로운 포스팅을 작성한다.',
  })
  @ApiOkResponse({ description: 'OK', type: Posting })
  async create(@Req() request, @Body() createPostingDto: CreatePostingDto) {
    if (
      new Date(createPostingDto.endDate) < new Date(createPostingDto.startDate)
    ) {
      throw new BadRequestException(
        'endDate는 startDate와 같거나 더 나중의 날짜여야 합니다.'
      );
    }

    const userId = ''; // TODO: request['user'].id; (현재 id 필드 값은 닉네임)
    return this.postingsService.createPosting(userId, createPostingDto);
  }

  // @Get()
  // @ApiOperation({
  //   summary: '포스팅 검색 결과 API',
  //   description: '전달된 쿼리 값에 따른 검색 결과를 반환한다.',
  // })
  // @ApiOkResponse({ description: 'OK', type: [Posting] })
  // search(@Query() searchPostingDto: SearchPostingDto) {
  //   //return this.postingsService.search(searchPostingDto);
  // }

  @Get(':id')
  @ApiOperation({
    summary: '포스팅 로드 API',
    description: 'id 값에 해당되는 포스팅을 반환한다.',
  })
  @ApiOkResponse({ description: 'OK', type: Posting })
  async findOne(@Param('id') id: string) {
    const userId = ''; // TODO: request['user'].id; (현재 id 필드 값은 닉네임)
    const posting = await this.postingsService.findPosting(id);

    return {
      ...posting,
      days: this.createDaysList(posting.startDate, posting.days),
      liked: posting.liked.length,
      report: posting.report.length,
      isLiked: posting.liked.some((liked) => liked.user === userId),
      isOwner: posting.writer.id === userId,
    };
  }

  @Put(':id')
  @ApiOperation({
    summary: '포스팅 수정 API',
    description: 'id 값에 해당되는 포스팅을 수정한다.',
  })
  @ApiOkResponse({ description: 'OK' })
  update(@Param('id') id: string, @Body() updatePostingDto: UpdatePostingDto) {
    const userId = ''; // TODO: request['user'].id; (현재 id 필드 값은 닉네임)
    return this.postingsService.updatePosting(id, userId, updatePostingDto);
  }

  // @Delete(':id')
  // @ApiOperation({
  //   summary: '포스팅 삭제 API',
  //   description: 'id 값에 해당되는 포스팅을 삭제한다.',
  // })
  // @ApiOkResponse({ description: 'OK' })
  // remove(@Param('id') id: string) {
  //   // TODO: JWT에서 user id 가져오기
  //   return this.postingsService.remove(id, '');
  // }

  // @Get('/titles')
  // @ApiOperation({
  //   summary: '포스팅 제목 검색 API',
  //   description:
  //     '전달된 키워드로 시작하는 제목을 가진 포스팅의 제목을 반환한다.',
  // })
  // @ApiOkResponse({ description: 'OK', type: [String] })
  // searchByKeyWord(@Query('keyword') keyword: string) {
  //   //return this.postingsService.searchByKeyWord(keyword);
  // }

  // @Post(':id/like')
  // @ApiOperation({
  //   summary: '포스팅 좋아요 API',
  //   description:
  //     'id 값에 해당되는 포스팅에 좋아요가 추가되거나 삭제된다. (토글)',
  // })
  // @ApiOkResponse({ description: 'OK' })
  // toggleLike(@Param('id') id: string) {
  //   // TODO: JWT에서 사용자 ID 가져오기
  //   return this.postingsService.toggleLike(id, '');
  // }

  // @Post(':id/report')
  // @ApiOperation({
  //   summary: '게시글 신고',
  //   description: 'id에 해당하는 게시글을 신고한다.',
  // })
  // @ApiCreatedResponse({
  //   description: 'OK',
  // })
  // report(@Param('id') id: string) {
  //   // TODO: JWT에서 사용자 ID 가져오기
  //   return this.postingsService.report(id, '');
  // }

  private createDaysList(startDate: Date, days: number) {
    const weekdays = ['일', '월', '화', '수', '목', '금', '토'];
    const standardDate = new Date(startDate);

    return Array.from({ length: days }, (_, index) => {
      const date = new Date(startDate);
      date.setDate(standardDate.getDate() + index);
      return `${date.getDate()}${weekdays[date.getDay()]}`;
    });
  }
}
