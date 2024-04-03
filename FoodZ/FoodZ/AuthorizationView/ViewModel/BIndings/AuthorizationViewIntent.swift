//
//  AuthorizationViewIntent.swift
//  Foodp2p
//
//  Created by surexnx on 21.03.2024.
//

import Foundation

enum AuthorizationViewIntent {
    case onClose
    case proccedButtonTapedAuthorizate(_ credentials: [String: String])
    case proccedButtonTapedGoRegistrate
    case onReload
}
