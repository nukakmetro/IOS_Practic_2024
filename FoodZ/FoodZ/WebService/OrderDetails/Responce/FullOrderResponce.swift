//
//  FullOrderResponce.swift
//  FoodZ
//
//  Created by surexnx on 28.04.2024.
//

import Foundation

struct FullOrderResponce: Decodable {
    var orderId: String
    var orderPrice: String
    var orderTime: String
    var username: String
    var phoneNumber: String?
    var firstName: String?
    var secondName: String?
}
