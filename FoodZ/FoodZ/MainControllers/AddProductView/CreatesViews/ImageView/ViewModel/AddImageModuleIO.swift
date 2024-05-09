//
//  AddImageModuleIO.swift
//  FoodZ
//
//  Created by surexnx on 06.05.2024.
//

import Foundation

protocol AddImageModuleInput: AnyObject {
    func addImageModuleGiveAwayProduct(product: ProductCreator)
}

protocol AddImageModuleOutput: AnyObject {
    func addImageModuleDidLoad(input: AddImageModuleInput)
    func imageProccesedTappedSaveButton(product: ProductCreator)
    func proccesedCloseView(product: ProductCreator)
    func proccesedTappedAddProduct()
}
