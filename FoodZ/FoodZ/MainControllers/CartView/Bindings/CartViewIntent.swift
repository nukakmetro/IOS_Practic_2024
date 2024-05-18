//
//  CartViewIntent.swift
//  FoodZ
//
//  Created by surexnx on 17.05.2024.
//

import Foundation

enum CartViewIntent {
    case onClose
    case onDidLoad
    case onLoad
    case onReload
    case proccesedTappedButtonReduce(id: Int, inputCell: CartCellInput)
    case proccesedTappedButtonIncrease(id: Int, inputCell: CartCellInput)
    case proccesedTappedButtonTrash(id: Int)
    case proccesedTappedButtonCell(id: Int)
}
