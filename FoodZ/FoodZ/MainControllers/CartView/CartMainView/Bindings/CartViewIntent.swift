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
    case proccesedTappedButtonReduce(id: Int)
    case proccesedTappedButtonIncrease(id: Int)
    case proccesedTappedButtonTrash(id: Int)
    case proccesedTappedButtonCell(id: Int)
    case proccesedTappedButtonSave(id: Int)
    case proccesedTappedButtonPay
}
