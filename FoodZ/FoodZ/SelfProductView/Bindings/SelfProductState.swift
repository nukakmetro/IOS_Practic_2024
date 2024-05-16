//
//  SelfProductState.swift
//  FoodZ
//
//  Created by surexnx on 13.05.2024.
//

import Foundation

enum SelfProductState {
    case loading
    case content([SelfProductSectionType], viewData: SelfProductContentData)
    case error
}
