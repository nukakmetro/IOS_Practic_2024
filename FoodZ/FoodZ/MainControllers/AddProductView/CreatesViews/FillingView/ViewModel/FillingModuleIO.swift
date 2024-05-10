//
//  FilingModuleIO.swift
//  FoodZ
//
//  Created by surexnx on 05.05.2024.
//

import Foundation

protocol FillingModuleInput: AnyObject {
    func proccesedGiveAwayProduct(product: ProductCreator)
}

protocol FillingModuleOutput: AnyObject {
    func fillingModuleDidLoad(input: FillingModuleInput)
    func proccesedTappedNextView(product: ProductCreator)
    func fillingProccesedTappedSaveButton(product: ProductCreator)
}
