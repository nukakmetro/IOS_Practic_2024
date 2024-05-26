//
//  OrderItemResponce.swift
//  FoodZ
//
//  Created by surexnx on 25.05.2024.
//

import Foundation

struct OrderItemResponce: Decodable {
    var productId: Int
    var price: Int
    var quantity: Int
    var productName: String
    var productCategory: String
}
