//
//  ProfilMainModuleIO.swift
//  FoodZ
//
//  Created by surexnx on 21.04.2024.
//

import Foundation

protocol ProfileMainModuleInput: AnyObject {}

protocol ProfileMainModuleOutput: AnyObject {
    func processedProfileItemTaped()
    func processedAddressBookItemTaped()
    func processedPaymentItemTaped()
    func processedOrderItemTaped()
    func processedSettingItemTaped()
    func processedHelpItemTaped()
    func processedExitItemTaped()
}
