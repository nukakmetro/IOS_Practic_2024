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
    private let currentOrder: OrderCurrenModuleOutput

    // MARK: Initialization

    init(output: OrdersModuleOutput, _ currentOrder: OrderCurrenModuleOutput) {
        self.output = output
        self.currentOrder = currentOrder
    }

    // MARK: Internal properties

    func build() -> UIViewController {
        let remoteRepository = UserRepository()
        let viewModel = OrdersViewModel(output: output, repository: remoteRepository)
        let controllers = [CurrentOrdersBuilder(output: currentOrder).build(), PastOrdersBuilder().build()]
        let controller = OrdersViewController(viewModel: viewModel, viewControllers: controllers)
        return controller
    }
}
