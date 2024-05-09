//
//  File.swift
//  FoodZ
//
//  Created by surexnx on 06.05.2024.
//

import Foundation
import UIKit

final class FillingBuilder: Builder {

    // MARK: Private properties

    private let output: FillingModuleOutput

    // MARK: Initialization

    init(output: FillingModuleOutput) {
        self.output = output
    }

    // MARK: Internal properties

    func build() -> UIViewController {
        let repository = UserRepository()
        let viewModel = FillingViewModel(output: output, repository: repository)
        let controller = FillingViewController(viewModel: viewModel)
        controller.hidesBottomBarWhenPushed = true
        return controller
    }
}
