//
//  AutoLoginUseCase.swift
//  traveline
//
//  Created by 김태현 on 12/7/23.
//  Copyright © 2023 traveline. All rights reserved.
//

import Combine
import Foundation

protocol AutoLoginUseCase {
    func requestLogin() -> AnyPublisher<Bool, Error>
}

final class AutoLoginUseCaseImpl: AutoLoginUseCase {
    
    private let repository: AuthRepository
    
    init(repository: AuthRepository) {
        self.repository = repository
    }
    
    func requestLogin() -> AnyPublisher<Bool, Error> {
        guard let isFirstEntry = UserDefaultsList.isFirstEntry,
              !isFirstEntry else {
            return Just(false)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        }
        
        return Future {
            let accessToken = try await self.repository.refresh()
            KeychainList.accessToken = accessToken
            return true
        }.eraseToAnyPublisher()
    }
    
}
