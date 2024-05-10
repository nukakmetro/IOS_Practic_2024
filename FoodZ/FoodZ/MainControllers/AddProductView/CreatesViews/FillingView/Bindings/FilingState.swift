//
//  FilingState.swift
//  FoodZ
//
//  Created by surexnx on 05.05.2024.
//

import Foundation

enum FilingState {
    case loading
    case content([FillingCellType])
    case error([FillingCellType])
}
