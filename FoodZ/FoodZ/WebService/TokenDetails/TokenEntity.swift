//
//  TokenEntity.swift
//  FoodZ
//
//  Created by surexnx on 15.04.2024.
//

import Foundation

struct TokenEntity: Decodable {
    private var accessToken: String
    private var refreshToken: String

    init() {
        self.accessToken = "accessToken"
        self.refreshToken = "refreshToken"
    }

    mutating func setNewTokens(tokenEntity: TokenEntity) {
        self = tokenEntity
    }

    func getAccessToken() -> String { return accessToken }
    func getRefreshToken() -> String { return refreshToken }
}

struct RefreshRequest: Encodable {
    private let refreshToken: String

    init(refreshToken: String) {
        self.refreshToken = refreshToken
    }
}
