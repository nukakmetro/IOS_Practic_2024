//
//  DetailPickUpPointState.swift
//  FoodZ
//
//  Created by surexnx on 20.05.2024.
//

import Foundation

enum DetailPickUpPointState {
    case loading
    case content(displayData: DetailPickUpPointViewData)
    case error
}
