//
//  TimelineSample.swift
//  traveline
//
//  Created by 김태현 on 11/22/23.
//  Copyright © 2023 traveline. All rights reserved.
//

import Foundation

// TODO: - 서버 연동시 지우기
enum TimelineSample {
    static func makeTravelInfo() -> TimelineTravelInfo {
        return .init(
            travelTitle: "부산 여행 ~",
            startDate: "2023.11.21",
            endDate: "2023.11.23",
            isLiked: true, 
            isOwner: true,
            tags: [
                .init(title: "2박 3일", type: .period),
                .init(title: "부산", type: .region),
                .init(title: "가을", type: .season),
                .init(title: "맛집", type: .theme),
                .init(title: "힐링", type: .theme),
                .init(title: "액티비티", type: .theme),
                .init(title: "효도", type: .theme)
            ],
            days: ["01 일", "02 월", "03 화"],
            day: 1
        )
    }
    
    static func makeCardList() -> TimelineCardList {
        return [
            .init(
                detailId: "1",
                thumbnailURL: "https://picsum.photos/600/400",
                imagePath: "https://picsum.photos/600/400",
                title: "광안리 최고~",
                place: "광안리 해수욕장",
                content: "어쩌고 저쩌고 이러쿵 저러쿵",
                time: "14:05",
                latitude: 35.153246,
                longitude: 129.119150
            ),
            .init(
                detailId: "",
                thumbnailURL: "https://picsum.photos/600/300",
                imagePath: "https://picsum.photos/600/300",
                title: "호텔 오션뷰 최고",
                place: "호텔 센트럴베이",
                content: "너무 깔끔하고 좋네요",
                time: "16:00",
                latitude: 35.151311,
                longitude: 129.116401
            ),
            .init(
                detailId: "",
                thumbnailURL: "https://picsum.photos/500/400",
                imagePath: "https://picsum.photos/500/400",
                title: "맛있는게 많네요",
                place: "민락더마켓",
                content: "주차장도 넓고 바로 앞에 바다가 있어요",
                time: "18:00",
                latitude: 35.154261,
                longitude: 129.127022
            ),
            .init(
                detailId: "",
                thumbnailURL: "https://picsum.photos/500/300",
                imagePath: "https://picsum.photos/500/300",
                title: "산책하기 좋아요",
                place: "해운대 해수욕장",
                content: "어쩌고 저쩌고 이러쿵 저러쿵",
                time: "19:30",
                latitude: 35.158528,
                longitude: 129.159876
            ),
            .init(
                detailId: "",
                thumbnailURL: "https://picsum.photos/600/400",
                imagePath: "https://picsum.photos/600/400",
                title: "곱창전골이 맛있어요",
                place: "해성막창집 본점",
                content: "웨이팅이 길고 주차가 어렵고 어쩌고",
                time: "21:00",
                latitude: 35.163869,
                longitude: 129.163293
            ),
            .init(
                detailId: "",
                thumbnailURL: "https://picsum.photos/700/400",
                imagePath: "https://picsum.photos/700/400",
                title: "곱창전골이 맛있어요",
                place: "해성막창집 본점",
                content: "웨이팅이 길고 주차가 어렵고 어쩌고",
                time: "21:00",
                latitude: 35.163869,
                longitude: 129.163293
            ),
            .init(
                detailId: "",
                thumbnailURL: "https://picsum.photos/700/500",
                imagePath: "https://picsum.photos/700/500",
                title: "곱창전골이 맛있어요",
                place: "해성막창집 본점",
                content: "웨이팅이 길고 주차가 어렵고 어쩌고",
                time: "21:00",
                latitude: 35.163869,
                longitude: 129.163293
            ),
            .init(
                detailId: "",
                thumbnailURL: "https://picsum.photos/700/600",
                imagePath: "https://picsum.photos/700/600",
                title: "곱창전골이 맛있어요",
                place: "해성막창집 본점",
                content: "웨이팅이 길고 주차가 어렵고 어쩌고",
                time: "21:00",
                latitude: 35.163869,
                longitude: 129.163293
            ),
            .init(
                detailId: "",
                thumbnailURL: "https://picsum.photos/700/700",
                imagePath: "https://picsum.photos/700/700",
                title: "곱창전골이 맛있어요",
                place: "해성막창집 본점",
                content: "웨이팅이 길고 주차가 어렵고 어쩌고",
                time: "21:00",
                latitude: 35.163869,
                longitude: 129.163293
            )
        ]
    }
    
    static func makeCard() -> TimelineCardInfo {
        .init(
            detailId: "",
            thumbnailURL: "",
            imagePath: "",
            title: "광안리 최고~",
            place: "광안리 해수욕장",
            content: "어쩌고 저쩌고 이러쿵 저러쿵",
            time: "14:05",
            latitude: 35.153246,
            longitude: 129.119150
        )
    }
    
}
