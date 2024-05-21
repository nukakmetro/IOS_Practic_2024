//
//  MainTabBarBuilder.swift
//  Foodp2p
//
//  Created by surexnx on 19.03.2024.
//

import Foundation

class MainTabBarBuilder: Builder {

    let authUser: UserExitProcessorDelegate

    init(authUser: UserExitProcessorDelegate) {
        self.authUser = authUser
    }

    func build() -> MainTabBarController {
        let tabBar = MainTabBarController(authUser: authUser)
        tabBar.tabBar.backgroundColor = AppColor.background.color
        return tabBar
    }
}
