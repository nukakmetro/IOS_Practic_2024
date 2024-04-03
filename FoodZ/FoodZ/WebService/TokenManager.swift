//
//  TokenManager.swift
//  Foodp2p
//
//  Created by surexnx on 07.03.2024.
//

import Alamofire

struct TokenManager: Decodable {

    private var accessToken: String
    private var refreshToken: String

    static let shared = TokenManager()

    init() {
        accessToken = ""
        refreshToken = ""
    }

    mutating func updateToken(tokenManager: TokenManager) {
        accessToken = tokenManager.accessToken
        refreshToken = tokenManager.refreshToken
    }

    mutating func updateToken(access: String, refresh: String) {
        accessToken = access
        refreshToken = refresh
    }

    func getRefreshToken() -> String? {
        if refreshToken == "" {
            return nil
        } else {
            return refreshToken
        }
    }

    func getAccessToken() -> String? {
        if accessToken == "" {
            return nil
        } else {
            return accessToken
        }
    }

    mutating func exit() {
        accessToken = ""
        refreshToken = ""
    }
}
