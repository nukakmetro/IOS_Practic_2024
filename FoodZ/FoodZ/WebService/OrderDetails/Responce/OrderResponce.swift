//
//  OrderResponce.swift
//  FoodZ
//
//  Created by surexnx on 28.04.2024.
//

import Foundation

struct OrderResponce: Decodable {
    var orderId: Int
    var orderPrice: Int
    var orderTime: String
    var orderType: String
}
