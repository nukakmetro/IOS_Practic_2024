//
//  SavedViewState.swift
//  FoodZ
//
//  Created by surexnx on 03.05.2024.
//

import Foundation

enum SavedState {
    case loading
    case content(displaydata: [SavedCellType])
    case error
}
