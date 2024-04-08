//
//  HomeModulIO.swift
//  FoodZ
//
//  Created by surexnx on 27.03.2024.
//

import Foundation

protocol HomeModuleInput: AnyObject {}

protocol HomeModuleOutput: AnyObject {
    func proccesedButtonTapToSearch()
    func proccesedButtonTapToProduct()
}
