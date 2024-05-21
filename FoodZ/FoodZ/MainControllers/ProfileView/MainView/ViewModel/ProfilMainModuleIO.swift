//
//  ProfilMainModuleIO.swift
//  FoodZ
//
//  Created by surexnx on 21.04.2024.
//

import Foundation

protocol ProfileMainModuleInput: AnyObject {
    func proccessedUpdateAddress()
}

protocol ProfileMainModuleOutput: AnyObject {
    func processedProfileItemTapped()
    func processedAddressBookItemTapped()
    func processedPaymentItemTapped()
    func processedOrderItemTapped()
    func processedSettingItemTapped()
    func processedHelpItemTapped()
    func processedExitItemTapped()
    func profileMainModuleDidLoad(input: ProfileMainModuleInput)
}
