//
//  OrdersViewBuilder.swift
//  FoodZ
//
//  Created by surexnx on 27.04.2024.
//

import Foundation
import UIKit

final class OrdersViewBuilder: Builder {

    // MARK: Private properties

    private let output: OrdersModuleOutput

    // MARK: Initialization

    init(output: OrdersModuleOutput) {
        self.output = output
    }

    // MARK: Internal properties

    func build() -> UIViewController {
        let remoteRepository = UserRepository()
        let viewModel = OrdersViewModel(output: output, repository: remoteRepository)
        let controllers = [CurrentOrdersBuilder().build(), PastOrdersBuilder().build()]
        let controller = OrdersViewController(viewModel: viewModel, viewControllers: controllers)
        return controller
    }
}
