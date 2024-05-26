//
//  OrdersPageState.swift
//  FoodZ
//
//  Created by surexnx on 28.04.2024.
//

import Foundation

enum OrdersPageState {
    case loading
    case content(_ displayData: [OrderSectionType])
    case error
}
