//
//  FilingModuleIO.swift
//  FoodZ
//
//  Created by surexnx on 05.05.2024.
//

import Foundation

protocol FillingModuleInput: AnyObject {
    func proccesedGiveAwayProduct(product: ProductEntity)
}

protocol FillingModuleOutput: AnyObject {
    func fillingModuleDidLoad(input: FillingModuleInput)
    func proccesedTappedNextView(product: ProductEntity)
    func fillingProccesedTappedSaveButton(product: ProductEntity)
}
