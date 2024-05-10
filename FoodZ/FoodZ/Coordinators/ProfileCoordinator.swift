//
//  ProfileCoordinator.swift
//  FoodZ
//
//  Created by surexnx on 21.04.2024.
//

import Foundation
import UIKit

protocol UserExitProcessorDelegate: AnyObject {
    func processesUserExit()
}

final class ProfileCoordinator: Coordinator {

    // MARK: Internal properties
    weak var authUser: UserExitProcessorDelegate?
    weak var navigationController: UINavigationController?

    // MARK: Initializator

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        start()
    }
    // MARK: Internal methods

    func start() {
        showProfileMainView()
    }

    // MARK: Private methods

    private func showProfileMainView() {
        let controller = ProfileMainBuilder(output: self).build()
        navigationController?.pushViewController(controller, animated: false)
    }

    private func showOrdersView() {
        let controller = OrdersViewBuilder(output: self).build()
        navigationController?.pushViewController(controller, animated: false)

    }

    private func popView() {
        navigationController?.popViewController(animated: false)
    }
}

// MARK: ProfileMainModuleOutput protocol

extension ProfileCoordinator: ProfileMainModuleOutput {

    func processedProfileItemTapped() {

    }

    func processedAddressBookItemTapped() {

    }

    func processedPaymentItemTapped() {

    }

    func processedOrderItemTapped() {
        showOrdersView()
    }

    func processedSettingItemTapped() {

    }

    func processedHelpItemTapped() {

    }

    func processedExitItemTapped() {
        authUser?.processesUserExit()
    }
}

// MARK: OrdersModuleOutput protocol

extension ProfileCoordinator: OrdersModuleOutput {

}
