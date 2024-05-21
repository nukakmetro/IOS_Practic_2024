//
//  CartModuleIO.swift
//  FoodZ
//
//  Created by surexnx on 17.05.2024.
//

import Foundation

protocol CartModuleInput: AnyObject {}

protocol CartModuleOutput: AnyObject {
    func proccesedTappedProductCell(id: Int)
}