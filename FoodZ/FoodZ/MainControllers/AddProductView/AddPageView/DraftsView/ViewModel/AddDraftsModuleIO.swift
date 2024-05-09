//
//  AddDraftsModuleIO.swift
//  FoodZ
//
//  Created by surexnx on 04.05.2024.
//

import Foundation

// MARK: - AddDraftsModuleInput

protocol AddDraftsModuleInput: AnyObject {

    func proccesedSaveProduct(product: ProductCreator)
    func proccesedSaveDeleteProduct(product: ProductCreator)
}

protocol AddDraftsModuleOutput: AnyObject {
    func proccesedTappedNext(_ product: ProductCreator)
    func addDraftsModuleDidLoad(input: AddDraftsModuleInput)
}
