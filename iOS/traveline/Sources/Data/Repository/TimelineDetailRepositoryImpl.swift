//
//  TimelineDetailRepositoryImpl.swift
//  traveline
//
//  Created by KiWoong Hong on 2023/12/02.
//  Copyright © 2023 traveline. All rights reserved.
//

import Foundation

final class TimelineDetailRepositoryImpl: TimelineDetailRepository {
    
    let network: NetworkType
    
    init(network: NetworkType) {
        self.network = network
    }
    
    func fetchTimelineDetailInfo(id: String) async throws -> TimelineDetailInfo {
        
        let timelineDetailResponseDTO = try await network.request(
            endPoint: PostingEndPoint.specificPosting,
            type: TimelineDetailResponseDTO.self
        )
        
        return timelineDetailResponseDTO.toDomain()
    }
    
}
