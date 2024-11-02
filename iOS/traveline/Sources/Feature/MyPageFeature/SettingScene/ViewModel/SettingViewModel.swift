//
//  SettingViewModel.swift
//  traveline
//
//  Created by KiWoong Hong on 2023/12/05.
//  Copyright © 2023 traveline. All rights reserved.
//

import AuthenticationServices
import Combine
import Foundation

enum SettingAction: BaseAction {
    case logoutButtonTapped
    case withdrawalButtonTapped
    case didCompleteWithAppleAuth(ASAuthorization)
    case didCompleteWithError
}

enum SettingSideEffect: BaseSideEffect {
    case logout
    case requestAppleId(AppleIDRequest)
    case requestWithdraw(Bool)
    case error(String)
}

struct SettingState: BaseState {
    var moveToLogin: Bool = false
    var appleIDRequests: [AppleIDRequest]?
}

final class SettingViewModel: BaseViewModel<SettingAction, SettingSideEffect, SettingState> {
    
    private let useCase: SettingUseCase
    
    init(useCase: SettingUseCase) {
        self.useCase = useCase
    }
    
    override func transform(action: Action) -> SideEffectPublisher {
        switch action {
        case .logoutButtonTapped:
            return reqeustLogout()
            
        case .withdrawalButtonTapped:
            return requestAppleId()
            
        case .didCompleteWithAppleAuth(let auth):
            return requestWithdraw(auth: auth)
            
        case .didCompleteWithError:
            return .just(.error("did complete with error"))
        }
    }
    
    override func reduceState(state: SettingState, effect: SettingSideEffect) -> SettingState {
        var newState = state
        
        switch effect {
        case .logout:
            newState.moveToLogin = true
            
        case .requestAppleId(let request):
            newState.appleIDRequests = [request]
            
        case let .requestWithdraw(isSuccess):
            newState.moveToLogin = true
            
        case .error:
            break
        }
        
        return newState
    }
    
}

extension SettingViewModel {
    private func reqeustLogout() -> SideEffectPublisher {
        useCase.logout()
        return .just(.logout)
    }
    
    private func requestAppleId() -> SideEffectPublisher {
        let request = useCase.requestAppleId()
        return .just(.requestAppleId(request))
    }
    
    private func requestWithdraw(auth: ASAuthorization) -> SideEffectPublisher {
        
        guard let appleIDCredential = auth.credential as? ASAuthorizationAppleIDCredential else {
            return .just(.error("failed request withdraw"))
        }
        
        guard let identityToken = appleIDCredential.identityToken,
              let authorizationCode = appleIDCredential.authorizationCode,
              let identityTokenString = String(data: identityToken, encoding: .utf8),
              let authorizationCodeString = String(data: authorizationCode, encoding: .utf8) else {
            return .just(.error("failed get iDtoken, authCode"))
        }
        
        let withdrawRequest: WithdrawRequest = .init(
            idToken: identityTokenString,
            authorizationCode: authorizationCodeString
        )
        
        return useCase.requestWithdrawal(withdrawRequest)
            .map { isSuccess in
                return .requestWithdraw(isSuccess)
            }
            .catch { _ in
                return Just(.error("failed request withdrawal"))
            }
            .eraseToAnyPublisher()
    }
}
