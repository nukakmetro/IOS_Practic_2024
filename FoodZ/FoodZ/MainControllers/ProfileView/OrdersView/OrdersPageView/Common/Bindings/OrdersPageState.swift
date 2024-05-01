//
//  OrdersPageState.swift
//  FoodZ
//
//  Created by surexnx on 28.04.2024.
//

import Foundation

enum OrdersPageState {
    case loading
    case content(_ orders: [OrdersViewCellType])
    case error(_ orders: [OrdersViewCellType])
}
