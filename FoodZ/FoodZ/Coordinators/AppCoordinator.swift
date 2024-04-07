//
//  AppCoordinator.swift
//  Foodp2p
//
//  Created by surexnx on 17.03.2024.
//

import Foundation
import UIKit

class AppCoordinator {

    // MARK: Internal properties

    var navigationController: UINavigationController?

    // MARK: Initializator

    init(navController: UINavigationController) {
        self.navigationController = navController
    }

    // MARK: Internal methods

    func start() {
        let isAuth = false
        if isAuth {
            showTabBar()
        } else {
            showAuthorizationFlow()
        }
    }

    // MARK: Private methods

    private func showAuthorizationFlow() {

        let authorizationCoordinator = CoordinatorFactory().createAuthorizationCoordinator(navController: navigationController)
        authorizationCoordinator.delegate = self
        authorizationCoordinator.start()
    }

    private func showTabBar() {
        let tapbarController = MainTabBarController()
        if let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate, let window = sceneDelegate.window {
            window.rootViewController = tapbarController
            window.makeKeyAndVisible()
        }
    }
}

// MARK: ChangeCoordinator protocol

extension AppCoordinator: ChangeCoordinator {
    func change() {
        navigationController = nil
        showTabBar()
    }
}
