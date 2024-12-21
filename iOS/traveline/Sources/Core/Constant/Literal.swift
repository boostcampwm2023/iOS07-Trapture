//
//  Literal.swift
//  traveline
//
//  Created by 김영인 on 2023/11/17.
//  Copyright © 2023 traveline. All rights reserved.
//

import Foundation

enum Literal {
    static let empty: String = ""
    static let boundary: String = "Boundary-\(UUID().uuidString)"
    
    enum URL {
        static var baseURL: String {
            #if DEBUG
            Bundle.main.object(forInfoDictionaryKey: Literal.InfoPlistKey.devURL) as? String ?? ""
            #else
            Bundle.main.object(forInfoDictionaryKey: Literal.InfoPlistKey.prodURL) as? String ?? ""
            #endif
        }
        static var imageBaseURL: String = URL.baseURL + "/"
    }
    
    enum InfoPlistKey {
        static let devURL: String = "DevURL"
        static let prodURL: String = "ProdURL"
    }
    
    enum Tag {
        static let region: String = "지역"
        static let period: String = "기간"
        static let season: String = "계절"
        static let theme: String = "테마"
        static let cost: String = "비용"
        static let costSubtitle: String = "단위: 만원"
        static let people: String = "인원"
        static let with: String = "함께"
        static let transportation: String = "이동수단"
        
        enum ThemeDetail {
            static let healing: String = "힐링"
            static let activity: String = "액티비티"
            static let camping: String = "캠핑"
            static let restaurant: String = "맛집"
            static let art: String = "예술"
            static let emotion: String = "감성"
            static let nature: String = "자연"
            static let shopping: String = "쇼핑"
            static let filialPiety: String = "효도"
        }
        
        enum CostDetail {
            static let under10: String = "0 - 10"
            static let under50: String = "10 - 50"
            static let under100: String = "50 - 100"
            static let over100: String = "100 -"
            static let won: String = "만 원"
        }
        
        enum PeopleDetail {
            static let one: String = "1인"
            static let two: String = "2인"
            static let three: String = "3인"
            static let four: String = "4인"
            static let overFive: String = "5인 이상"
        }
        
        enum WithDetail {
            static let family: String = "가족"
            static let friend: String = "친구"
            static let couple: String = "연인"
            static let pet: String = "반려동물"
        }
        
        enum TransportationDetail {
            static let publicTransport: String = "대중교통"
            static let drive: String = "자차"
        }
    }
    
    enum Filter {
        static let sort: String = "정렬"
        
        enum SortDetail {
            static let recent: String = "최신순"
            static let like: String = "좋아요순"
        }
        
        enum RegionDetail {
            static let seoul: String = "서울"
            static let busan: String = "부산"
            static let daegu: String = "대구"
            static let incheon: String = "인천"
            static let gwangju: String = "광주"
            static let daejeon: String = "대전"
            static let ulsan: String = "울산"
            static let sejong: String = "세종"
            static let gyeonggi: String = "경기도"
            static let gangwon: String = "강원도"
            static let chungbuk: String = "충청북도"
            static let chungnam: String = "충청남도"
            static let jeonbuk: String = "전라북도"
            static let jeonnam: String = "전라남도"
            static let gyeongbuk: String = "경상북도"
            static let gyeongnam: String = "경상남도"
            static let jeju: String = "제주도"
        }
        
        enum PeriodDetail {
            static let one: String = "당일치기"
            static let two: String = "1박 2일"
            static let three: String = "2박 3일"
            static let overThree: String = "3박 -"
            static let week: String = "일주일 -"
            static let month: String = "한 달 -"
        }
        
        enum SeasonDetail {
            static let spring: String = "봄"
            static let summer: String = "여름"
            static let fall: String = "가을"
            static let winter: String = "겨울"
        }
    }
    
    enum Action {
        static let modify: String = "수정하기"
        static let delete: String = "삭제하기"
        static let report: String = "신고하기"
        static let block: String = "차단하기"
        static let translate: String = "번역하기"
    }
    
    enum Query {
        enum SortDetail {
            static let recent: String = "최신순"
            static let like: String = "좋아요순"
        }
        
        enum RegionDetail {
            static let seoul: String = "서울"
            static let busan: String = "부산"
            static let daegu: String = "대구"
            static let incheon: String = "인천"
            static let gwangju: String = "광주"
            static let daejeon: String = "대전"
            static let ulsan: String = "울산"
            static let sejong: String = "세종"
            static let gyeonggi: String = "경기"
            static let gangwon: String = "강원"
            static let chungbuk: String = "충북"
            static let chungnam: String = "충남"
            static let jeonbuk: String = "전북"
            static let jeonnam: String = "전남"
            static let gyeongbuk: String = "경북"
            static let gyeongnam: String = "경남"
            static let jeju: String = "제주"
        }
        
        enum PeriodDetail {
            static let one: String = "당일치기"
            static let two: String = "1박 2일"
            static let three: String = "2박 3일"
            static let overThree: String = "3박 ~"
            static let week: String = "일주일 ~"
            static let month: String = "한 달 ~"
        }
        
        enum SeasonDetail {
            static let spring: String = "봄"
            static let summer: String = "여름"
            static let fall: String = "가을"
            static let winter: String = "겨울"
        }
        
        enum ThemeDetail {
            static let healing: String = "힐링"
            static let activity: String = "액티비티"
            static let camping: String = "캠핑"
            static let restaurant: String = "맛집"
            static let art: String = "예술"
            static let emotion: String = "감성"
            static let nature: String = "자연"
            static let shopping: String = "쇼핑"
            static let filialPiety: String = "효도"
        }
        
        enum CostDetail {
            static let under10: String = "0 - 10만 원"
            static let under50: String = "10 - 50만 원"
            static let under100: String = "50 - 100만 원"
            static let over100: String = "100만 원 ~"
        }
        
        enum PeopleDetail {
            static let one: String = "1인"
            static let two: String = "2인"
            static let three: String = "3인"
            static let four: String = "4인"
            static let overFive: String = "5인 이상"
        }
        
        enum WithDetail {
            static let family: String = "가족"
            static let friend: String = "친구"
            static let couple: String = "연인"
            static let pet: String = "반려동물"
        }
        
        enum TransportationDetail {
            static let publicTransport: String = "대중교통"
            static let drive: String = "자차"
        }
    }
    
    enum Setting {
        static let termsOfServiceURL = "https://spiky-rat-16e.notion.site/b222abdf800e4a428a25582f2dc36290?pvs=4"
        static let privacyPolicyURL = "https://spiky-rat-16e.notion.site/886a133ee0f9473a83d5f3ed8b877498?pvs=4"
        static let openSourceLicenseURL = "https://spiky-rat-16e.notion.site/e8725bd989ea410390b6ef568324a439?pvs=4"
    }
}
