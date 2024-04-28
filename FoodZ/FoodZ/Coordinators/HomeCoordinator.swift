//
//  HomeCoordinator.swift
//  FoodZ
//
//  Created by surexnx on 27.03.2024.
//

import Foundation
import UIKit

final class HomeCoordinator {

    // MARK: Internal properties

    weak var navigationController: UINavigationController?

    // MARK: Initializator

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        start()
    }

    // MARK: Internal methods

    func start() {
        showHomeView()
    }

    // MARK: Private methods

    private func showHomeView() {
        let controller = HomeViewBuilder(output: self).build()
        navigationController?.pushViewController(controller, animated: false)
    }
    private func showSearcView() {
        let controller = SearchViewBuilder(output: self).build()
        navigationController?.pushViewController(controller, animated: false)
    }

    private func closePushView() {
        navigationController?.popViewController(animated: false)
    }
}

// MARK: HomeViewOutput protocol

extension HomeCoordinator: HomeModuleOutput {
    func proccesedButtonTapToSearch() {
        showSearcView()
    }

    func proccesedButtonTapToProduct() {

    }
}

// MARK: SearchModuleOutput protocol

extension HomeCoordinator: SearchModuleOutput {
    func moduleWantsToClose() {
        closePushView()
    }
}
