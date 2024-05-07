//
//  CoordinatorFactory.swift
//  Foodp2p
//
//  Created by surexnx on 17.03.2024.
//

import Foundation
import UIKit

class CoordinatorFactory {

    func createAuthorizationCoordinator(_ delegate: ChangeCoordinator, navigationController: UINavigationController?) -> Coordinator {
        let coordinator = AuthorizationCoordinator(navigationController: navigationController)
        coordinator.delegate = delegate
        return coordinator
    }

    func createAppCoordinator(_ window: UIWindow?) -> AppCoordinator {
        AppCoordinator(window: window)
    }

    func createHomeCoordinators(navigationController: UINavigationController) -> Coordinator {
        HomeCoordinator(navigationController: navigationController)
    }
    
    func createProfileCoordinator(authUser: UserExitProcessorDelegate, navigationController: UINavigationController) -> Coordinator {
        let coordinator = ProfileCoordinator(navigationController: navigationController)
        coordinator.authUser = authUser
        return coordinator
    }

    func crateSavedCoordinator(navigationController: UINavigationController) -> Coordinator {
        SavedCoordinator(navigationController: navigationController)
    }

    func createAddCoordinator(navigationController: UINavigationController) -> Coordinator { 
        AddCoordinator(navigationController: navigationController)
    }
}
