//
//  CartViewBuilder.swift
//  FoodZ
//
//  Created by surexnx on 17.05.2024.
//

import Foundation
import UIKit

final class CartViewBuilder: Builder {

    // MARK: Private properties

    private let output: CartModuleOutput

    // MARK: Initializators

    init(output: CartModuleOutput) {
        self.output = output
    }

    // MARK: Internal properties

    func build() -> UIViewController {
        let remoteRepository = CartRepository()
        let viewModel = CartViewModel(output: output, remoteRepository: remoteRepository)
        let controller = CartViewController(viewModel: viewModel)
        return controller
    }
}
