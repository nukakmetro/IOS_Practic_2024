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

    weak var navigationController: UINavigationController?
    weak var productInput: SelfProductModuleInput?

    // MARK: Initialization

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
        navigationController?.pushViewController(controller, animated: true)
    }

    private func showSelfProductView() {
        let controller = SelfProductBuilder(output: self).build()
        navigationController?.pushViewController(controller, animated: true)
    }

    private func closePushView() {
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - HomeViewOutput

extension HomeCoordinator: HomeModuleOutput {
    func proccesedTappedButtonSearch() {
        showSearcView()
    }

    func proccesedTappedProductCell(id: Int) {
        showSelfProductView()
        productInput?.proccesedSendId(id: id)
    }
}

// MARK: - SearchModuleOutput

extension HomeCoordinator: SearchModuleOutput {
    func proccesedTappedCell(_ id: Int) {
        showSelfProductView()
        productInput?.proccesedSendId(id: id)
    }

    func moduleWantsToClose() {
        closePushView()
    }
}

// MARK: - SelfProductModuleOutput

extension HomeCoordinator: SelfProductModuleOutput {
    func proccesedTappedButtonCart() {
        NotificationCenter.default.post(name: .selectCartTab, object: nil)
    }

    func selfProductModuleDidLoad(input: SelfProductModuleInput) {
        productInput = input
    }
}
