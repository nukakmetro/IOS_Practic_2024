//
//  OrdersPageIntent.swift
//  FoodZ
//
//  Created by surexnx on 28.04.2024.
//

import Foundation

enum OrdersPageIntent {
    case onDidLoad
    case onClose
    case onReload
    case proccesedTappedCell(_ id: Int)
}
