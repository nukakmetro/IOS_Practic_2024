//
//  RegistrationViewIntent.swift
//  Foodp2p
//
//  Created by surexnx on 21.03.2024.
//

import Foundation

enum RegistrationViewIntent {
    case onClose
    case proccedButtonTapedRegistrate(_ userRegistrationRequst: UserRegistrationRequest)
    case onDidLoad
    case proccedButtonTapedGoToAuth
}
