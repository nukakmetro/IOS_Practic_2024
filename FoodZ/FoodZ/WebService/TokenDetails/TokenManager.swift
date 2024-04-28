//
//  TokenManager.swift
//  Foodp2p
//
//  Created by surexnx on 07.03.2024.
//

import Foundation

final class TokenManager {

    private var tokenEntity: TokenEntity
    static let shared = TokenManager()

    init() {
        tokenEntity = TokenEntity()
    }

    func updateToken(tokenEntity: TokenEntity) {
        self.tokenEntity = tokenEntity
    }

    func getRefreshToken() -> RefreshRequest {
        return RefreshRequest(refreshToken: tokenEntity.getRefreshToken())
    }

    func getAccessToken() -> String {
        return tokenEntity.getAccessToken()
    }
}
