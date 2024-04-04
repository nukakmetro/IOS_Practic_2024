//
//  AuthorizationModulBuilder.swift
//  Foodp2p
//
//  Created by surexnx on 14.03.2024.
//

import Foundation
import UIKit

final class AuthorizationModulBuilder: Builder {

    // MARK: Private properties

    private let output: AuthModuleOutput

    // MARK: Initializator

    init(output: AuthModuleOutput) {
        self.output = output
    }

    // MARK: Internal methods

    func build () -> UIViewController {
        let networkManager = MockNetworkManager()
        let viewModel = AuthorizationViewModel(output: output, network: networkManager)
        let controller = AuthorizationViewController(viewModel: viewModel)
        return controller
    }
}
