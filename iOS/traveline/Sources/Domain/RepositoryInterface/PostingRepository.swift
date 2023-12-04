//
//  PostingRepository.swift
//  traveline
//
//  Created by 김태현 on 11/30/23.
//  Copyright © 2023 traveline. All rights reserved.
//

import Foundation

protocol PostingRepository {
    func fetchPostingList() async throws -> TravelList
    func fetchMyPostingList() async throws -> TravelList
    func fetchRecentKeyword() -> [String]?
    func saveRecentKeyword(_ keyword: String)
    func saveRecentKeywordList(_ keywordList: [String])
    func deleteRecentKeyword(_ keyword: String)
}
