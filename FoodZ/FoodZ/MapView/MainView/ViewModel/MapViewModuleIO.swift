//
//  MapViewModuleIO.swift
//  FoodZ
//
//  Created by surexnx on 20.05.2024.
//

import Foundation

protocol MapModuleInput: AnyObject {}

protocol MapModuleOutput: AnyObject {
    func proccesedTappedAnnotation(pickUpPointId: Int)
}
