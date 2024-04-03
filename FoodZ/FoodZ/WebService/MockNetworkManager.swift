//
//  MockNetworkManager.swift
//  Foodp2p
//
//  Created by surexnx on 17.03.2024.
//

import Foundation
import CoreData

class MockNetworkManager: NetworkManagerProtocol {

    func registration(credentials: [String: String]) -> String? {
        let name = credentials["username"]
        let pass = credentials["password"]
        if name == "admin" && pass == "1" {
            return nil
        } else {
            return "error"
        }
    }

    func authenticate(credentials: [String: String]) -> String? {
        let name = credentials["username"]
        let pass = credentials["password"]
        if name == "admin" && pass == "1" {
            return nil
        } else {
            return "error"
        }
    }

    func getHomeViewSections() -> [Section]? {
        return Bundle.main.decode([Section].self, from: "WEbService/Foodz.json")
    }
}
