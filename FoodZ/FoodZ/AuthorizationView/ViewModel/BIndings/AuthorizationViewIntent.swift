//
//  AuthorizationViewIntent.swift
//  Foodp2p
//
//  Created by surexnx on 21.03.2024.
//

import Foundation

enum AuthorizationViewIntent {
    case onClose
    case onDidLoad
    case proccedButtonTapedAuthorizate(_ userRequest: UserRequest)
    case proccedButtonTapedGoRegistrate
    case onReload
}
