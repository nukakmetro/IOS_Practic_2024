//
//  CartModuleIO.swift
//  FoodZ
//
//  Created by surexnx on 17.05.2024.
//

import Foundation

protocol CartModuleInput: AnyObject {
    func proccesedReload()
}

protocol CartModuleOutput: AnyObject {
    func proccesedTappedProductCell(id: Int)
    func proccesedTappedButtonPay()
    func cartModuleDidLoad(input: CartModuleInput)
}
