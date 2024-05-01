//
//  ProfileMainBuilder.swift
//  FoodZ
//
//  Created by surexnx on 24.04.2024.
//

import Foundation
import UIKit

final class ProfileMainBuilder: Builder {

    // MARK: Private properties

    private let output: ProfileMainModuleOutput

    // MARK: Initialization

    init(output: ProfileMainModuleOutput) {
        self.output = output
    }

    // MARK: Internal properties

    func build() -> UIViewController {
        let remoteRepository = UserRepository()
        let viewModel = ProfileViewModel(output: output, repository: remoteRepository)
        let controller = ProfileViewController(viewModel: viewModel)
        return controller
    }
}
