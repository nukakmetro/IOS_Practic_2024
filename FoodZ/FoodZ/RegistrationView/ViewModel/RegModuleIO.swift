//
//  RegModuleOutput.swift
//  Foodp2p
//
//  Created by surexnx on 21.03.2024.
//

import Foundation

protocol RegModuleInput: AnyObject {}

protocol RegModuleOutput: AnyObject {
    func presentAuthorization()
    func userRegistrate()
}
