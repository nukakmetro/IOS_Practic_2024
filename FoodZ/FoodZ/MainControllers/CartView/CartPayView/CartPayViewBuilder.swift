//
//  CartPayViewBuilder.swift
//  FoodZ
//
//  Created by surexnx on 23.05.2024.
//

import Foundation
import UIKit

final class CartPayViewBuilder: Builder {

    // MARK: Private properties

    private let output: CartPayModuleOutput

    // MARK: Initializators

    init(output: CartPayModuleOutput) {
        self.output = output
    }

    // MARK: Internal properties

    func build() -> UIViewController {
        let remoteRepository = CartRepository()
        let viewModel = CartPayViewModel(output: output, remoteRepository: remoteRepository)
        let controller = CartPayViewController(viewModel: viewModel)
        controller.navigationController?.isNavigationBarHidden = false
        controller.navigationItem.title = "Оформление заказа"
        controller.tabBarController?.tabBar.isHidden = true
        return controller
    }
}
