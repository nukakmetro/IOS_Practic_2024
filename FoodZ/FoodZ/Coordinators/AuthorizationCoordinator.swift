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

    var navigationController: UINavigationController
    weak var delegate: ChangeCoordinator?

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        showAuthView()
    }

    func showAuthView() {
        let controller = AuthorizationModulBuilder(output: self).build()
        navigationController.pushViewController(controller, animated: false)
    }

    func showRegView() {
        let controller = RegistrationModulBuilder(output: self).build()
        navigationController.pushViewController(controller, animated: false)
    }

}
extension AuthorizationCoordinator: RegModuleOutput {

    func userRegistrate() {
        showAuthView()
    }
    func presentAuthorization() {
        showAuthView()
    }
}
extension AuthorizationCoordinator: AuthModuleOutput {

    func presentRegistration() {
        showRegView()
    }
    func userAuthorizate() {
        delegate?.change()
    }
}
