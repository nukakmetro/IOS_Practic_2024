//
//  FilingIntent.swift
//  FoodZ
//
//  Created by surexnx on 05.05.2024.
//

import Foundation

enum FilingIntent {
    case onDidLoad
    case onLoad([FillingCellType])
    case onClose
    case onReload
    case proccesedTappedContinue([FillingData])
}
