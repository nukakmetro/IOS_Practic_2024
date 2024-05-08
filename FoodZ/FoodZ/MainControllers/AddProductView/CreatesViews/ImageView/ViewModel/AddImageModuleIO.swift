//
//  AddImageModuleIO.swift
//  FoodZ
//
//  Created by surexnx on 06.05.2024.
//

import Foundation

protocol AddImageModuleInput: AnyObject {
    func addImageModuleGiveAwayProduct(product: ProductEntity)
}

protocol AddImageModuleOutput: AnyObject {
    func addImageModuleDidLoad(input: AddImageModuleInput)
    func imageProccesedTappedSaveButton(product: ProductEntity)
    func proccesedCloseView(product: ProductEntity)
    func proccesedTappedAddProduct()
}
