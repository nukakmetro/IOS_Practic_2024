//
//  CoordinatorFactory.swift
//  Foodp2p
//
//  Created by surexnx on 17.03.2024.
//

import Foundation
import UIKit

class CoordinatorFactory {

    func createAuthorizationCoordinator(navigationController: UINavigationController?) -> AuthorizationCoordinator {
        AuthorizationCoordinator(navigationController: navigationController)
    }
    func createAppCoordinator(_ window: UIWindow?) -> AppCoordinator {
        AppCoordinator(window: window)
    }
    func createHomeCoordinators(navigationController: UINavigationController) -> HomeCoordinator {
        HomeCoordinator(navigationController: navigationController)
    }
    func createProfileCoordinator(navigationController: UINavigationController) -> ProfileCoordinator {
        ProfileCoordinator(navigationController: navigationController)
    }
}
