//
//  UserInfoModel.swift
//  FoodZ
//
//  Created by surexnx on 24.04.2024.
//

import Foundation

struct UserInfoModel: Decodable {
    var id: Int
    var username: String
    var image: Int?
    var number: String?

    init(username: String, nubmer: String, id: Int, image: Int) {
        self.username = username
        self.number = nubmer
        self.id = id
        self.image = image
    }
}
