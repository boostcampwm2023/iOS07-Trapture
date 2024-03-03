//
//  RegionFilter.swift
//  traveline
//
//  Created by 김영인 on 2023/11/24.
//  Copyright © 2023 traveline. All rights reserved.
//

import Foundation

enum RegionFilter: DetailFilterType {
    case none
    case seoul
    case busan
    case daegu
    case incheon
    case gwangju
    case daejeon
    case ulsan
    case sejong
    case gyeonggi
    case gangwon
    case chungbuk
    case chungnam
    case jeonbuk
    case jeonnam
    case gyeongbuk
    case gyeongnam
    case jeju
    
    var title: String {
        switch self {
        case .seoul:
            return Literal.Filter.RegionDetail.seoul
        case .busan:
            return Literal.Filter.RegionDetail.busan
        case .daegu:
            return Literal.Filter.RegionDetail.daegu
        case .incheon:
            return Literal.Filter.RegionDetail.incheon
        case .gwangju:
            return Literal.Filter.RegionDetail.gwangju
        case .daejeon:
            return Literal.Filter.RegionDetail.daejeon
        case .ulsan:
            return Literal.Filter.RegionDetail.ulsan
        case .sejong:
            return Literal.Filter.RegionDetail.sejong
        case .gyeonggi:
            return Literal.Filter.RegionDetail.gyeonggi
        case .gangwon:
            return Literal.Filter.RegionDetail.gangwon
        case .chungbuk:
            return Literal.Filter.RegionDetail.chungbuk
        case .chungnam:
            return Literal.Filter.RegionDetail.chungnam
        case .jeonbuk:
            return Literal.Filter.RegionDetail.jeonbuk
        case .jeonnam:
            return Literal.Filter.RegionDetail.jeonnam
        case .gyeongbuk:
            return Literal.Filter.RegionDetail.gyeongbuk
        case .gyeongnam:
            return Literal.Filter.RegionDetail.gyeongnam
        case .jeju:
            return Literal.Filter.RegionDetail.jeju
        default:
            return Literal.empty
        }
    }
    
    var query: String {
        switch self {
        case .seoul:
            return Literal.Query.RegionDetail.seoul
        case .busan:
            return Literal.Query.RegionDetail.busan
        case .daegu:
            return Literal.Query.RegionDetail.daegu
        case .incheon:
            return Literal.Query.RegionDetail.incheon
        case .gwangju:
            return Literal.Query.RegionDetail.gwangju
        case .daejeon:
            return Literal.Query.RegionDetail.daejeon
        case .ulsan:
            return Literal.Query.RegionDetail.ulsan
        case .sejong:
            return Literal.Query.RegionDetail.sejong
        case .gyeonggi:
            return Literal.Query.RegionDetail.gyeonggi
        case .gangwon:
            return Literal.Query.RegionDetail.gangwon
        case .chungbuk:
            return Literal.Query.RegionDetail.chungbuk
        case .chungnam:
            return Literal.Query.RegionDetail.chungnam
        case .jeonbuk:
            return Literal.Query.RegionDetail.jeonbuk
        case .jeonnam:
            return Literal.Query.RegionDetail.jeonnam
        case .gyeongbuk:
            return Literal.Query.RegionDetail.gyeongbuk
        case .gyeongnam:
            return Literal.Query.RegionDetail.gyeongnam
        case .jeju:
            return Literal.Query.RegionDetail.jeju
        default:
            return Literal.empty
        }
    }
}
