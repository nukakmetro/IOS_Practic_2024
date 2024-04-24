//
//  ProfileCoordinator.swift
//  FoodZ
//
//  Created by surexnx on 21.04.2024.
//

import Foundation
import UIKit

final class ProfileCoordinator: Coordinator {
    
    // MARK: Internal properties

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

    private func backView() {
        navigationController?.popViewController(animated: false)
    }

}

// MARK: RegModuleOutput ProfileMainModuleOutput

extension ProfileCoordinator: ProfileMainModuleOutput {
    func processedProfileItemTaped() {

    }

    func processedAddressBookItemTaped() {

    }

    func processedPaymentItemTaped() {

    }

    func processedOrderItemTaped() {

    }

    func processedSettingItemTaped() {

    }

    func processedHelpItemTaped() {

    }

    func processedExitItemTaped() {

    }
}
