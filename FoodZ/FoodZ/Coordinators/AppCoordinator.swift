//
//  AppCoordinator.swift
//  Foodp2p
//
//  Created by surexnx on 17.03.2024.
//

import Foundation
import UIKit

class AppCoordinator: Coordinator {

    var navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let isAuth = false
        if isAuth {
            showTabBar()
        } else {
            showAuthorizationFlow()
        }
    }

    func showAuthorizationFlow() {

        let authorizationCoordinator = CoordinatorFactory().createAuthorizationCoordinator(navController: navigationController)
        authorizationCoordinator.delegate = self
        authorizationCoordinator.start()
    }

    func showTabBar() {
        let tapbarController = MainTabBarController()
        if let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate, let window = sceneDelegate.window {
            window.rootViewController = tapbarController
            window.makeKeyAndVisible()
        }
    }
}

extension AppCoordinator: ChangeCoordinator {
    func change() {
        showTabBar()
    }
}
