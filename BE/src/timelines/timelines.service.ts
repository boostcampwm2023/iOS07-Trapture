import {
  Injectable,
  ForbiddenException,
  NotFoundException,
} from '@nestjs/common';
import { firstValueFrom } from 'rxjs';
import { HttpService } from '@nestjs/axios';
import { Transactional } from 'typeorm-transactional';
import { CreateTimelineDto } from './dto/create-timeline.dto';
import { UpdateTimelineDto } from './dto/update-timeline.dto';
import { TimelinesRepository } from './timelines.repository';
import { Timeline } from './entities/timeline.entity';
import { StorageService } from '../storage/storage.service';
import { PostingsService } from '../postings/postings.service';
import { KAKAO_KEYWORD_SEARCH, PAPAGO_URL } from './timelines.constants';
import { PostingsRepository } from '../postings/repositories/postings.repository';

@Injectable()
export class TimelinesService {
  constructor(
    private readonly timelinesRepository: TimelinesRepository,
    private readonly postingsRepository: PostingsRepository,
    private readonly postingsService: PostingsService,
    private readonly storageService: StorageService,
    private readonly httpService: HttpService
  ) {}

  @Transactional()
  async create(
    userId: string,
    file: Express.Multer.File,
    createTimelineDto: CreateTimelineDto
  ) {
    let imagePath: string;

    try {
      const posting = await this.postingsService.findOne(
        createTimelineDto.posting
      );

      if (posting.writer.id !== userId) {
        throw new ForbiddenException(
          '본인이 작성한 게시글에 대해서만 타임라인을 생성할 수 있습니다.'
        );
      }

      const timeline = await this.initialize(createTimelineDto);
      timeline.posting = posting;

      if (file) {
        const filePath = `${userId}/${posting.id}/`;
        const { path } = await this.storageService.upload(filePath, file);
        imagePath = path;
        timeline.image = imagePath;

        if (!posting.thumbnail) {
          await this.postingsRepository.updateThumbnail(posting.id, imagePath);
        }
      }

      return this.timelinesRepository.save(timeline);
    } catch (error) {
      if (imagePath) {
        this.storageService.delete(imagePath);
      }

      throw error;
    }
  }

  async findAll(postingId: string, day: number) {
    const timelines = await this.timelinesRepository.findAll(postingId, day);

    return Promise.all(
      timelines.map(async (timeline) => {
        const imageUrl = timeline.image
          ? await this.storageService.getImageUrl(timeline.image)
          : null;
        return {
          ...timeline,
          image: imageUrl,
          imagePath: timeline.image,
        };
      })
    );
  }

  async findOneWithURL(id: string) {
    const timeline = await this.findOne(id);
    const imagePath = timeline.image;

    if (imagePath) {
      timeline.image = await this.storageService.getImageUrl(imagePath);
    }

    return { ...timeline, imagePath };
  }

  @Transactional()
  async update(
    id: string,
    userId: string,
    image: Express.Multer.File,
    updateTimelineDto: UpdateTimelineDto
  ) {
    let imagePath: string;

    try {
      const timeline = await this.findOne(id);
      const isThumbnail = timeline.image === timeline.posting.thumbnail;
      const updatedTimeline = await this.initialize(updateTimelineDto);
      updatedTimeline.id = id;

      if (image) {
        const imagePlainPath = `${userId}/${timeline.posting.id}/`;
        const { path } = await this.storageService.upload(
          imagePlainPath,
          image
        );
        imagePath = path;
        updatedTimeline.image = imagePath;
      }

      const updatedResult = await this.timelinesRepository.update(
        id,
        updatedTimeline
      );

      if (isThumbnail) {
        await this.findOneAndUpdateThumbnail(timeline.posting.id);
      }

      if (timeline.image) {
        await this.storageService.delete(timeline.image);
      }

      return updatedResult;
    } catch (error) {
      if (imagePath) {
        this.storageService.delete(imagePath);
      }

      throw error;
    }
  }

  @Transactional()
  async remove(id: string) {
    const timeline = await this.findOne(id);
    await this.timelinesRepository.remove(timeline);

    if (timeline.image === timeline.posting.thumbnail) {
      await this.findOneAndUpdateThumbnail(timeline.posting.id);
    }

    if (timeline.image) {
      await this.storageService.delete(timeline.image);
    }

    return timeline;
  }

  private async initialize(
    timelineDto: CreateTimelineDto | UpdateTimelineDto
  ): Promise<Timeline> {
    const timeline = new Timeline();
    Object.assign(timeline, timelineDto);
    return timeline;
  }

  private async findOne(id: string) {
    const timeline = await this.timelinesRepository.findOne(id);

    if (!timeline) {
      throw new NotFoundException('타임라인이 존재하지 않습니다.');
    }

    return timeline;
  }

  async findCoordinates(place: string, offset: number, limit: number) {
    const url = `${KAKAO_KEYWORD_SEARCH}?query=${place}&page=${offset}&size=${limit}`;
    const {
      data: { documents },
    } = await firstValueFrom(
      this.httpService.get(url, {
        headers: { Authorization: `KakaoAK ${process.env.KAKAO_REST_API_KEY}` },
      })
    );

    return documents;
  }

  async translate(id: string) {
    const { description } = await this.findOne(id);
    const body = {
      source: 'ko',
      target: 'en',
      text: description,
    };
    const {
      data: {
        message: { result },
      },
    } = await firstValueFrom(
      this.httpService.post(PAPAGO_URL, body, {
        headers: {
          'Content-Type': 'application/json',
          'X-NCP-APIGW-API-KEY-ID': process.env.X_NCP_APIGW_API_KEY_ID,
          'X-NCP-APIGW-API-KEY': process.env.X_NCP_APIGW_API_KEY,
        },
      })
    );

    return { description: result.translatedText };
  }

  private async findOneAndUpdateThumbnail(postingId: string) {
    const result =
      await this.timelinesRepository.findOneWithNonEmptyImage(postingId);
    await this.postingsRepository.updateThumbnail(
      postingId,
      result ? result.image : ''
    );
  }
}
