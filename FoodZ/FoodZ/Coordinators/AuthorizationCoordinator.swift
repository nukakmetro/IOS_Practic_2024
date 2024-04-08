//
//  AuthorizationCoordinator.swift
//  Foodp2p
//
//  Created by surexnx on 17.03.2024.
//

import Foundation
import UIKit
protocol ChangeCoordinator: AnyObject {
    func change()
}

class AuthorizationCoordinator: Coordinator {

    // MARK: Internal properties

    weak var navigationController: UINavigationController?
    weak var delegate: ChangeCoordinator?

    // MARK: Initializator

    init(navigationController: UINavigationController?) {
        self.navigationController = navigationController
    }

    // MARK: Internal methods

    func start() {
        showAuthView()
    }

    // MARK: Private methods

    private func showAuthView() {
        let controller = AuthorizationModulBuilder(output: self).build()
        navigationController?.pushViewController(controller, animated: false)

    }

    private func clouseRegView() {
        navigationController?.popViewController(animated: false)
    }

    private func showRegView() {
        let controller = RegistrationModulBuilder(output: self).build()
        navigationController?.pushViewController(controller, animated: false)
    }

}

// MARK: RegModuleOutput protocol

extension AuthorizationCoordinator: RegModuleOutput {
    func didToTap() {

    }
    func userRegistrate() {
        clouseRegView()
    }
    func presentAuthorization() {
        clouseRegView()
    }
}

// MARK: AuthModuleOutput protocol

extension AuthorizationCoordinator: AuthModuleOutput {

    func presentRegistration() {
        showRegView()
    }
    func userAuthorizate() {
        delegate?.change()
    }
}
