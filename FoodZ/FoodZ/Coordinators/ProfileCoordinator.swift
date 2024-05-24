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

    // MARK: Private properties

    weak private var detailPickUpPointInput: DetailPickUpPointModuleInput?
    weak private var profileMainInput: ProfileMainModuleInput?

    // MARK: Internal properties

    weak var authUser: UserExitProcessorDelegate?
    weak var navigationController: UINavigationController?

    // MARK: Initialization

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

    private func showMapView() {
        let controller = MapViewBuilder(output: self).build()
        navigationController?.pushViewController(controller, animated: false)
    }

    private func showDetailPickUpPoint() {
        let controller = DetailPickUpPointViewBuilder(output: self).build()
        navigationController?.present(controller, animated: true)
    }

    private func dismissPresentedController() {
        navigationController?.presentedViewController?.dismiss(animated: true, completion: nil)
    }

    private func popView() {
        navigationController?.popViewController(animated: false)
    }

    private func popToRootView() {
        if (navigationController?.viewControllers.first) != nil {
            navigationController?.popToRootViewController(animated: true)
        }
    }
}

// MARK: - DetailPickUpPointModuleOutput

extension ProfileCoordinator: DetailPickUpPointModuleOutput {

    func detailPickUpPointModuleDidLoad(input: DetailPickUpPointModuleInput) {
        detailPickUpPointInput = input
    }

    func proccesedCloseMapModuleClose() {
        dismissPresentedController()
        profileMainInput?.proccessedUpdateAddress()
        popToRootView()
    }
}

// MARK: - ProfileMainModuleOutput

extension ProfileCoordinator: ProfileMainModuleOutput {
    func profileMainModuleDidLoad(input: ProfileMainModuleInput) {
        profileMainInput = input
    }

    func processedProfileItemTapped() {

    }

    func processedAddressBookItemTapped() {
        showMapView()
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

// MARK: - OrdersModuleOutput

extension ProfileCoordinator: OrdersModuleOutput {

}

// MARK: - MapModuleOutput

extension ProfileCoordinator: MapModuleOutput {

    func proccesedTappedButtonBack() {
        popView()
    }

    func proccesedTappedAnnotation(pickUpPointId: Int) {
        showDetailPickUpPoint()
        detailPickUpPointInput?.proccesDidLoad(id: pickUpPointId)
    }
}
