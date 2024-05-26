//
//  HomeViewIntent.swift
//  FoodZ
//
//  Created by surexnx on 27.03.2024.
//

import Foundation

enum HomeViewIntent {
    case onClose
    case onDidLoad
    case onLoad
    case proccesedTappedButtonSearch
    case onReload
    case proccesedTappedLikeButton(id: Int)
    case proccesedTappedCell(id: Int)
}
