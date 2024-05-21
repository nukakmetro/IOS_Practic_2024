//
//  MapViewState.swift
//  FoodZ
//
//  Created by surexnx on 20.05.2024.
//

import Foundation

enum MapViewState {
    case loading
    case content(displayData: [PickUpPointAnnotation])
    case error
}
