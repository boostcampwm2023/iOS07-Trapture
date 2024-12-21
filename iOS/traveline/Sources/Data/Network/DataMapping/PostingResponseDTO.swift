//
//  PostingResponseDTO.swift
//  traveline
//
//  Created by 김태현 on 11/30/23.
//  Copyright © 2023 traveline. All rights reserved.
//

import Foundation

typealias PostingListResponseDTO = [PostingResponseDTO]

struct PostingResponseDTO: Decodable {
    let id: String
    let title: String
    let createdAt: String
    let thumbnail: String?
    let thumbnailPath: String?
    let period: String
    let headcount: String?
    let budget: String?
    let location: String
    let season: String
    let vehicle: String?
    let theme: [String]?
    let withWho: [String]?
    let writer: WriterDTO
    let likeds: String

    enum CodingKeys: String, CodingKey {
        case createdAt = "created_at"
        case id, title, thumbnail, thumbnailPath, period, headcount, budget,
            location, season, vehicle, theme, withWho, writer, likeds
    }
}

// MARK: - Mapping

extension PostingResponseDTO {
    func toDomain() -> TravelListInfo {
        let profile: Profile = .init(
            id: writer.id,
            imageURL: writer.avatar ?? Literal.empty,
            imagePath: writer.avatarPath ?? Literal.empty,
            name: writer.name
        )
        
        return .init(
            id: id,
            imageURL: Literal.URL.imageBaseURL + (thumbnail ?? Literal.empty),
            imagePath: thumbnailPath ?? Literal.empty,
            title: title,
            profile: profile,
            like: Int(likeds) ?? 0,
            isLiked: true,
            tags: [
                .init(title: location, type: .region),
                .init(title: period, type: .people),
                .init(title: season, type: .season)
            ]
        )
    }
}
