//
//  SelfProductModuleIO.swift
//  FoodZ
//
//  Created by surexnx on 14.05.2024.
//

import Foundation

protocol SelfProductModuleInput: AnyObject {
    func proccesedSendId(id: Int)
}

protocol SelfProductModuleOutput: AnyObject {
    func selfProductModuleDidLoad(input: SelfProductModuleInput)

}
