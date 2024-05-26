//
//  OrderResponce.swift
//  FoodZ
//
//  Created by surexnx on 28.04.2024.
//

import Foundation

struct OrderResponce: Decodable {
    var id: Int
    var totalPrice: Int
    var status: Int
    var whose: Bool
    var orderItems: [OrderItemResponce]
}
