//
//  TagType.swift
//  traveline
//
//  Created by 김영인 on 2023/11/17.
//  Copyright © 2023 traveline. All rights reserved.
//

import Foundation

enum TagType: CaseIterable {
    case location
    case period
    case season
    case theme
    case cost
    case people
    case with
    case transportation
    
    var color: TravelineColors.Color {
        switch self {
        case .location:
            TLColor.Tag.location
        case .period:
            TLColor.Tag.period
        case .season:
            TLColor.Tag.season
        case .theme:
            TLColor.Tag.theme
        case .cost:
            TLColor.Tag.cost
        case .people:
            TLColor.Tag.people
        case .with:
            TLColor.Tag.with
        case .transportation:
            TLColor.Tag.transportation
        }
    }
    
    var title: String {
        switch self {
        case .location:
            Literal.Tag.location
        case .period:
            Literal.Tag.period
        case .season:
            Literal.Tag.season
        case .theme:
            Literal.Tag.theme
        case .cost:
            Literal.Tag.cost
        case .people:
            Literal.Tag.people
        case .with:
            Literal.Tag.with
        case .transportation:
            Literal.Tag.transportation
        }
    }
    
    var subtitle: String? {
        switch self {
        case .cost:
            Literal.Tag.costSubtitle
        default:
            nil
        }
    }
    
    var detailTags: [String] {
        switch self {
        case .theme:
            ThemeTag.allCases.map { $0.title }
        case .cost:
            CostTag.allCases.map { $0.title }
        case .people:
            PeopleTag.allCases.map { $0.title }
        case .with:
            WithTag.allCases.map { $0.title }
        case .transportation:
            TransportationTag.allCases.map { $0.title }
        case .location, .period, .season:
            []
        }
    }
}