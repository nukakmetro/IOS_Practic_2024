//
//  AddImageState.swift
//  FoodZ
//
//  Created by surexnx on 06.05.2024.
//

import Foundation

enum AddImageState {
    case loading
    case content([AddImageCellType])
    case error
}
