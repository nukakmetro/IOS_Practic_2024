//
//  MainTabBarBuilder.swift
//  Foodp2p
//
//  Created by surexnx on 19.03.2024.
//

import Foundation

class MainTabBarBuilder: Builder {

    let authUser: ProcessUserExitDelegate

    init(authUser: ProcessUserExitDelegate) {
        self.authUser = authUser
    }

    func build() -> MainTabBarController {
        MainTabBarController(authUser: authUser)
    }
}
