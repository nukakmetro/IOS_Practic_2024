//
//  AuthorizationViewState.swift
//  Foodp2p
//
//  Created by surexnx on 21.03.2024.
//

import Foundation

enum AuthorizationViewState {
    case loading
    case content
    case error(_ error: String)
}
