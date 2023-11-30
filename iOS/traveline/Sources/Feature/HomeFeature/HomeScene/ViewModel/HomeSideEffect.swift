//
//  HomeSideEffect.swift
//  traveline
//
//  Created by 김영인 on 2023/11/27.
//  Copyright © 2023 traveline. All rights reserved.
//

import Foundation

enum HomeSideEffect: BaseSideEffect {
    case showRecent
    case showRelated(String)
    case showResult(String)
    case showList
    case showFilter(FilterType)
    case saveFilter([Filter])
    case showTravelWriting
}