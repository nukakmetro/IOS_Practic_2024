//
//  SearchViewState.swift
//  FoodZ
//
//  Created by surexnx on 03.04.2024.
//

import Foundation

enum SearchViewState {
    case loading
    case content(dispayData: [Section])
    case error(dispayData: [Section])
}
