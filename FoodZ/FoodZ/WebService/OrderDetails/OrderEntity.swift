//
//  OrderEntity.swift
//  FoodZ
//
//  Created by surexnx on 28.04.2024.
//

import Foundation

struct OrderEntity: Hashable {
    var orderId: String
    var orderPrice: String
    var orderTime: String
    var orderType: String

    init(orderId: String, orderPrice: String, orderTime: String, orderType: String) {
        self.orderId = orderId
        self.orderPrice = orderPrice
        self.orderTime = orderTime
        self.orderType = orderType
    }
}
