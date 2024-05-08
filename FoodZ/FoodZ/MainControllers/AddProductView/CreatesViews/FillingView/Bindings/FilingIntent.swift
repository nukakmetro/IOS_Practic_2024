//
//  FilingIntent.swift
//  FoodZ
//
//  Created by surexnx on 05.05.2024.
//

import Foundation

enum FilingIntent {
    case onDidLoad
    case onLoad
    case onClose
    case onReload
    case proccesedTappedSaveButton([FillingData])
    case proccesedTappedContinue([FillingData])
}
