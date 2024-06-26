//
//  RegistrationModulBuilder.swift
//  Foodp2p
//
//  Created by surexnx on 13.03.2024.
//

import Foundation
import UIKit

final class RegistrationModulBuilder: Builder {

    // MARK: Private properties

    private let output: RegModuleOutput

    // MARK: Initializators

    init(output: RegModuleOutput) {
        self.output = output
    }

    // MARK: Internal properties

    func build() -> UIViewController {
        let repository = UserRepository()
        let viewModel = RegistrationViewModel(output: output, repository: repository)
        let controller = RegistrationViewController(viewModel: viewModel)
        return controller
    }
}
