//
//  CartViewState.swift
//  FoodZ
//
//  Created by surexnx on 17.05.2024.
//

import Foundation

enum CartViewState {
    case loading
    case content(displayData: [CartSectionType])
    case error
}
