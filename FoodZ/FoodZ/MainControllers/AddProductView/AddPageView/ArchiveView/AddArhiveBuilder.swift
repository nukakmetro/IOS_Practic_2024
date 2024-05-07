//
//  AddArhiveBuilder.swift
//  FoodZ
//
//  Created by surexnx on 04.05.2024.
//

import Foundation
import UIKit

final class AddArhiveBuilder: Builder {

    // MARK: Private properties

    private let output: AddArhiveModuleOutput

    // MARK: Initialization

    init(output: AddArhiveModuleOutput) {
        self.output = output
    }

    // MARK: Internal properties

    func build() -> UIViewController {
        let repository = UserRepository()
        let viewModel = AddArhiveViewModel(output: output, repository: repository)
        let controller = AddArhiveViewController(viewModel: viewModel)
        return controller
    }
}
