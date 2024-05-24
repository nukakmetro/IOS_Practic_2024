//
//  CartPayState.swift
//  FoodZ
//
//  Created by surexnx on 19.05.2024.
//

import Foundation

enum CartPayState {
    case loading
    case content(displayData: [CartPaySectionType], totalPrice: String)
    case error
}
