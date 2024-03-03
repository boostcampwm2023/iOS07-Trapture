//
//  AutoLoginViewModel.swift
//  traveline
//
//  Created by 김태현 on 12/7/23.
//  Copyright © 2023 traveline. All rights reserved.
//

import Combine
import Foundation

enum AutoLoginAction: BaseAction {
    case startAutoLogin
}

enum AutoLoginSideEffect: BaseSideEffect {
    case finishDelay
    case finishLogin(Bool)
    case loginFailed(Error)
}

struct AutoLoginState: BaseState {
    var isFinishDelay: Bool = false
    var isSuccessLogin: Bool = false
    
    var moveToLogin: Bool {
        isFinishDelay && !isSuccessLogin
    }
    
    var moveToMain: Bool {
        isFinishDelay && isSuccessLogin
    }
}

final class AutoLoginViewModel: BaseViewModel<AutoLoginAction, AutoLoginSideEffect, AutoLoginState> {
    
    private let useCase: AutoLoginUseCase
    
    init(useCase: AutoLoginUseCase) {
        self.useCase = useCase
    }
    
    override func transform(action: AutoLoginAction) -> BaseViewModel<AutoLoginAction, AutoLoginSideEffect, AutoLoginState>.SideEffectPublisher {
        switch action {
        case .startAutoLogin:
            return Publishers.Merge(
                startDelay(),
                requestLogin()
            ).eraseToAnyPublisher()
        }
    }
    
    override func reduceState(state: AutoLoginState, effect: AutoLoginSideEffect) -> AutoLoginState {
        var newState = state
        
        switch effect {
        case .finishDelay:
            newState.isFinishDelay = true
            
        case let .finishLogin(isSuccess):
            newState.isSuccessLogin = isSuccess
            
        case let .loginFailed(error):
            newState.isSuccessLogin = false
            print(error)
        }
        
        return newState
    }
}

private extension AutoLoginViewModel {
    func startDelay() -> SideEffectPublisher {
        return Just(AutoLoginSideEffect.finishDelay)
            .delay(for: 1.0, scheduler: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    func requestLogin() -> SideEffectPublisher {
        return useCase.requestLogin()
            .map { isSuccess in
                return AutoLoginSideEffect.finishLogin(isSuccess)
            }
            .catch { error in
                return Just(AutoLoginSideEffect.loginFailed(error))
            }
            .eraseToAnyPublisher()
    }
}
