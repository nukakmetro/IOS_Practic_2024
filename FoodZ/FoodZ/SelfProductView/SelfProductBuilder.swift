//
//  SelfProductBuilder.swift
//  FoodZ
//
//  Created by surexnx on 14.05.2024.
//

import Foundation
import UIKit

final class SelfProductBuilder: Builder {

    // MARK: Private properties

    private let output: SelfProductModuleOutput

    // MARK: Initialization

    init(output: SelfProductModuleOutput) {
        self.output = output
    }

    // MARK: Internal properties

    func build() -> UIViewController {
        let repository = ProductRepository()
        let viewModel = SelfProductViewModel(output: output, repository: repository)
        let controller = SelfProductViewController(viewModel: viewModel)
        return controller
    }
}
