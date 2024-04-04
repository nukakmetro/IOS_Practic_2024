//
//  HomeCoordinator.swift
//  FoodZ
//
//  Created by surexnx on 27.03.2024.
//

import Foundation
import UIKit

final class HomeCoordinator: Coordinator {

    // MARK: Internal properties

    var navigationController: UINavigationController

    // MARK: Initializator

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    // MARK: Internal methods

    func start() {
        showHomeView()
    }

    // MARK: Private methods

    private func showHomeView() {
        let controller = HomeViewBuilder(output: self).build()
        navigationController.pushViewController(controller, animated: false)
    }
}

// MARK: HomeViewOutput protocol

extension HomeCoordinator: HomeModuleOutput {
    func presentRegistration() {
    }

    func userAuthorizate() {
    }
}
