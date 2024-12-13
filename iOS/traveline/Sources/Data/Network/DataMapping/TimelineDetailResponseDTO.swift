//
//  TimelineDetailResponseDTO.swift
//  traveline
//
//  Created by KiWoong Hong on 2023/12/02.
//  Copyright © 2023 traveline. All rights reserved.
//

import Foundation

struct TimelineDetailResponseDTO: Decodable {
    let id: String
    let title: String
    let day: Int
    let description: String
    let image: String?
    let imagePath: String?
    let coordX: Double?
    let coordY: Double?
    let date: String
    let place: String?
    let time: String
    let isOwner: Bool
    let posting: PostingID
}

struct PostingID: Decodable {
    let id: String
}

// MARK: - Mapping

extension TimelineDetailResponseDTO {
    func toDomain() -> TimelineDetailInfo {
        return .init(
            postingID: posting.id,
            id: id,
            title: title,
            day: day,
            description: description,
            imageURL: Literal.URL.imageBaseURL + (image ?? ""),
            imagePath: imagePath,
            coordX: coordX,
            coordY: coordY,
            date: date,
            location: place,
            time: time,
            isOwner: isOwner
        )
    }
    
}
