//
//  ProfileMainState.swift
//  FoodZ
//
//  Created by surexnx on 21.04.2024.
//

import Foundation

enum ProfileMainState {
    case loading
    case content([CellType])
    case error([CellType])
}
