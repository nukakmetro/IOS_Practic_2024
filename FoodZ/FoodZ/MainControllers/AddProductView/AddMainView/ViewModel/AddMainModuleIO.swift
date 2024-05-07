//
//  AddMainModuleIO.swift
//  FoodZ
//
//  Created by surexnx on 04.05.2024.
//

import Foundation

// MARK: - AddMainModuleInput

protocol AddMainModuleInput: AnyObject {

    func proccesedSaveProduct(product: ProductEntity)
    func proccesedSaveDeleteProduct(product: ProductEntity)
}

// MARK: - AddMainModuleOutput

protocol AddMainModuleOutput: AnyObject {

    func addMainModuleDidLoad(input: AddMainModuleInput)
    func proccesedMainTappedCreateProduct(product: ProductEntity)
}
