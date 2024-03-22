//
//  AuthorizationModulBuilder.swift
//  Foodp2p
//
//  Created by surexnx on 14.03.2024.
//

import Foundation
import UIKit

final class AuthorizationModulBuilder: Builder {

    private let output: AuthModuleOutput

    init(output: AuthModuleOutput) {
        self.output = output
    }
    func build () -> UIViewController {
        let networkManager = MockNetworkManager()
        let viewModel = AuthorizationViewModel(output: output, network: networkManager)
        let controller = AuthorizationViewController(viewModel: viewModel)
        return controller
    }
}
