import {
  Column,
  CreateDateColumn,
  Entity,
  JoinColumn,
  ManyToOne,
  OneToMany,
  PrimaryGeneratedColumn,
  RelationId,
} from 'typeorm';
import { Liked } from './liked.entity';
import { Report } from './report.entity';
import { User } from '../../users/entities/user.entity';
import { Timeline } from '../../timelines/entities/timeline.entity';

@Entity()
export class Posting {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @ManyToOne(() => User, (user) => user.postings, {
    onDelete: 'CASCADE',
  })
  @JoinColumn({ name: 'writer' })
  writer: User;

  @Column({ length: 14 })
  title: string;

  @CreateDateColumn({ name: 'created_at', type: 'timestamp' })
  createdAt: Date;

  @Column({ length: 255, nullable: true, default: null })
  thumbnail: string;

  @RelationId((posting: Posting) => posting.likeds)
  liked: { user: string; posting: string }[];

  @Column({ name: 'start_date', type: 'date' })
  startDate: Date;

  @Column({ name: 'end_date', type: 'date' })
  endDate: Date;

  @Column({ type: 'int' })
  days: number;

  @Column({ length: 14 })
  period: string;

  @Column({ length: 14, nullable: true })
  headcount: string;

  @Column({ length: 14, nullable: true })
  budget: string;

  @Column({ length: 14 })
  location: string;

  @Column({ length: 14 })
  season: string;

  @Column({ length: 14, nullable: true })
  vehicle: string;

  @Column({ type: 'json', nullable: true })
  theme: string[];

  @Column({ type: 'json', nullable: true })
  withWho: string[];

  @RelationId((posting: Posting) => posting.reports)
  report: { reporter: string; posting: string }[];

  @OneToMany(() => Timeline, (timeline) => timeline.postings)
  timelines: Timeline[];

  @OneToMany(() => Liked, (liked) => liked.postings)
  likeds: Liked[];

  @OneToMany(() => Report, (report) => report.postings)
  reports: Report[];
}
