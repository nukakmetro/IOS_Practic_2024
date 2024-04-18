//
//  UserRequest.swift
//  FoodZ
//
//  Created by surexnx on 18.04.2024.
//

import Foundation
struct UserRequest: Encodable {
    private let username: String
    private let password: String

    init(username: String, password: String) {
        self.username = username
        self.password = password
    }
}

struct UserRegistrationRequest: Encodable {
    private let username: String
    private let password: String
    private let confirmPassword: String

    init(username: String, password: String, confirmPassword: String) {
        self.username = username
        self.password = password
        self.confirmPassword = confirmPassword
    }

    func userPasswordComparison() -> Bool {
        password == confirmPassword
    }
}

struct UserRegistrationResponse: Decodable {
    private let id: Int
    private let username: String

    init(id: Int, username: String) {
        self.id = id
        self.username = username
    }
}
