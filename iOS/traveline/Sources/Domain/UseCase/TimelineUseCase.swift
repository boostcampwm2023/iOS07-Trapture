//
//  TimelineUseCase.swift
//  traveline
//
//  Created by 김태현 on 11/29/23.
//  Copyright © 2023 traveline. All rights reserved.
//

import Foundation
import Combine

protocol TimelineUseCase {
    func fetchTimelineInfo(id: TravelID) -> AnyPublisher<TimelineTravelInfo, Error>
    func fetchTimelineList(id: TravelID, day: Int) -> AnyPublisher<TimelineCardList, Error>
}

final class TimelineUseCaseImpl: TimelineUseCase {

    private let postingRepository: PostingRepository
    private let timelineRepository: TimelineRepository
    
    init(postingRepository: PostingRepository, timelineRepository: TimelineRepository) {
        self.postingRepository = postingRepository
        self.timelineRepository = timelineRepository
    }

    func fetchTimelineInfo(id: TravelID) -> AnyPublisher<TimelineTravelInfo, Error> {
        return Future { promise in
            Task {
                do {
                    let travelInfo = try await self.postingRepository.fetchTimelineInfo(id: id)
                    promise(.success(travelInfo))
                } catch {
                    promise(.failure(error))
                }
            }
        }.eraseToAnyPublisher()
    }
    
    func fetchTimelineList(id: TravelID, day: Int) -> AnyPublisher<TimelineCardList, Error> {
        return Future { promise in
            Task {
                do {
                    let timelineList = try await self.timelineRepository.fetchTimelineList(id: id, day: day)
                    promise(.success(timelineList))
                } catch {
                    promise(.failure(error))
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
}