//
//  SearchViewState.swift
//  FoodZ
//
//  Created by surexnx on 03.04.2024.
//

import Foundation

enum SearchViewState {
    case loading
    case content(dispayData: [SearchSomeSection])
    case error
}
