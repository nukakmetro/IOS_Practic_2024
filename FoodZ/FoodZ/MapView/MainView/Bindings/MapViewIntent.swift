//
//  MapViewIntent.swift
//  FoodZ
//
//  Created by surexnx on 20.05.2024.
//

import Foundation

enum MapViewIntent {
    case onClose
    case onDidLoad
    case onLoad
    case onReload
    case proccesedTappedAnnotation(pickUpPointId: Int)
}
