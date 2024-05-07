//
//  AddDraftsState.swift
//  FoodZ
//
//  Created by surexnx on 04.05.2024.
//

import Foundation

enum AddDraftsState {
    case loading
    case content(_ dispayData: [DraftsCellType])
    case error
}
