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

    private var window: UIWindow?

    // MARK: Initializator

    init(window: UIWindow?) {
        self.window = window
        NotificationCenter.default.addObserver(self, selector: #selector(handleSessionExpired), name: .sessionExpired, object: nil)
    }

    // MARK: Internal methods

    func start() {
        if TokenManager().getKeysBool() != nil {
            showTabBar()
        } else {
            showAuthorizationFlow()
        }
    }

    // MARK: Private methods

    private func showAuthorizationFlow() {
        let authorizationCoordinator = CoordinatorFactory().createAuthorizationCoordinator(self, navigationController: UINavigationController())
        authorizationCoordinator.start()
        window?.rootViewController = authorizationCoordinator.navigationController
        window?.makeKeyAndVisible()
    }

    private func showTabBar() {
        let tapbarController = MainTabBarBuilder(authUser: self).build()
        window?.rootViewController = tapbarController
        window?.makeKeyAndVisible()
    }

    @objc private func handleSessionExpired() {
        showAuthorizationFlow()
    }
}

// MARK: ChangeCoordinator protocol

extension AppCoordinator: ChangeCoordinator {
    func change() {
        showTabBar()
    }
}
// MARK: ProcessUserExitDelegate

extension AppCoordinator: UserExitProcessorDelegate {
    func processesUserExit() {
        TokenManager().keysClear()
        showAuthorizationFlow()
    }
}
