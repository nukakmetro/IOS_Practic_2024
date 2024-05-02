//
//  TokenManager.swift
//  Foodp2p
//
//  Created by surexnx on 07.03.2024.
//

import Foundation
import KeychainSwift

enum KeychainKeys: String {
    case accessToken = "accessToken"
    case refreshToken = "refreshToken"
}

final class TokenManager {
    private let keychain: KeychainSwift

    init() {
        keychain = KeychainSwift()
    }

    func updateToken(tokenEntity: TokenEntity) {
        keychain.set(tokenEntity.getAccessToken(), forKey: KeychainKeys.accessToken.rawValue)
        keychain.set(tokenEntity.getRefreshToken(), forKey: KeychainKeys.refreshToken.rawValue)
    }

    func getRefreshToken() -> RefreshRequest {
        return RefreshRequest(refreshToken: keychain.get(KeychainKeys.refreshToken.rawValue) ?? "")
    }

    func getAccessToken() -> String {
        return keychain.get(KeychainKeys.accessToken.rawValue) ?? ""
    }

    func keysClear() {
        keychain.delete(KeychainKeys.accessToken.rawValue)
        keychain.delete(KeychainKeys.refreshToken.rawValue)
        keychain.clear()
    }
    func getKeysBool() -> Bool? {
        return keychain.getBool(KeychainKeys.refreshToken.rawValue)
    }
}
