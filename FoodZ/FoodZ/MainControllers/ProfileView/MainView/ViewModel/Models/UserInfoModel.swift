//
//  UserInfoModel.swift
//  FoodZ
//
//  Created by surexnx on 24.04.2024.
//

import Foundation

struct UserInfoModel: Decodable {
    var userId: Int
    var username: String
    var imageId: Int?
    var number: String?
    var address: String?
}
