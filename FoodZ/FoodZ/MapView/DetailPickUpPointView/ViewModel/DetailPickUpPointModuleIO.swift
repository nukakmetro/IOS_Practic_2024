//
//  DetailPickUpPointModuleIO.swift
//  FoodZ
//
//  Created by surexnx on 20.05.2024.
//

import Foundation

protocol DetailPickUpPointModuleInput: AnyObject {
    func proccesDidLoad(id: Int)
}

protocol DetailPickUpPointModuleOutput: AnyObject {
    func detailPickUpPointModuleDidLoad(input: DetailPickUpPointModuleInput)
    func proccesedCloseMapModuleClose()
}
