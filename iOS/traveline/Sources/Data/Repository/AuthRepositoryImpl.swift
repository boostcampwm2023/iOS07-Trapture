//
//  AuthRepositoryImpl.swift
//  traveline
//
//  Created by KiWoong Hong on 2023/12/05.
//  Copyright © 2023 traveline. All rights reserved.
//

import AuthenticationServices
import Foundation

final class AuthRepositoryImpl: AuthRepository {
    
    private let network: NetworkType
    
    init(network: NetworkType) {
        self.network = network
    }
    
    func appleLogin(with info: AppleLoginRequest) async throws -> TLToken {
        let loginResponseDTO = try await network.request(
            endPoint: AuthEndPoint.appleLogin(info.toDTO()),
            type: LoginResponseDTO.self
        )
        
        return loginResponseDTO.toDomain()
    }
    
    func refresh() async throws -> String {
        let refreshResponseDTO = try await network.request(
            endPoint: AuthEndPoint.refresh,
            type: RefreshResponseDTO.self
        )
        
        return refreshResponseDTO.toDomain()
    }
    
    func logout() {
        KeychainList.accessToken = nil
        KeychainList.refreshToken = nil
    }
    
    func requestAppleId() -> AppleIDRequest {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        
        return request
    }
    
    func withdrawal(_ request: WithdrawRequest) async throws -> Bool {
        
        let result: WithdrawalResponseDTO = try await network.request(
            endPoint: AuthEndPoint.withdrawal(request.toDTO()),
            type: WithdrawalResponseDTO.self
        )
        
        return result.revoke
    }
    
}
