//
//  SelfOrderState.swift
//  FoodZ
//
//  Created by surexnx on 26.05.2024.
//

enum OrderSelfState {
    case loading
    case content([OrderSelfSectionType], viewData: OrderSelfViewData)
    case error
}
