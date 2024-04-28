//
//  HomeViewState.swift
//  FoodZ
//
//  Created by surexnx on 27.03.2024.
//

import Foundation

enum HomeViewState {
    case loading
    case content(dispayData: [Section])
    case error(displayData: [Section])
}
