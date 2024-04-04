//
//  NetworkManagerProtocol.swift
//  Foodp2p
//
//  Created by surexnx on 19.03.2024.
//

import Foundation

protocol NetworkManagerProtocol: AnyObject {
    func registration(credentials: [String: String]) -> String?
    func authenticate(credentials: [String: String]) -> String?
    func getHomeViewSections() -> [Section]?
}
