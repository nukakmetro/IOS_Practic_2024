//
//  AuthModulleIO.swift
//  Foodp2p
//
//  Created by surexnx on 21.03.2024.
//

import Foundation

protocol AuthModuleInput: AnyObject {}

protocol AuthModuleOutput: AnyObject {
    func presentRegistration()
    func userAuthorizate()
}
