//
//  CoordinatorFactory.swift
//  Foodp2p
//
//  Created by surexnx on 17.03.2024.
//

import Foundation
import UIKit

class CoordinatorFactory {

    func createAuthorizationCoordinator(navController: UINavigationController) -> AuthorizationCoordinator {
         AuthorizationCoordinator(navigationController: navController)
    }

    func createAppCoordinator(navController: UINavigationController) -> AppCoordinator {
        AppCoordinator(navigationController: navController)
    }
}
