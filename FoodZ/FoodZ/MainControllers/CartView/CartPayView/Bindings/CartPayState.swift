//
//  CartPayState.swift
//  FoodZ
//
//  Created by surexnx on 19.05.2024.
//

import Foundation

enum CartPayState {
    case loading
    case content(displayData: [CartSectionType], _ viewData: CartViewData)
    case error
}
