//
//  SelfOrderModuleIo.swift
//  FoodZ
//
//  Created by surexnx on 26.05.2024.
//

protocol OrderSelfModuleInput: AnyObject {
    func proccesedSendId(id: Int)
}

protocol OrderSelfModuleOutput: AnyObject {
    func selfProductModuleDidLoad(input: OrderSelfModuleInput)
    func proccesedTappedButtonCart()

}
