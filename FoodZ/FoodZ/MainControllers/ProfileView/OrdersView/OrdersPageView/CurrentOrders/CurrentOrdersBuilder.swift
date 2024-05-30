//
//  CurrentOrdersBuilder.swift
//  FoodZ
//
//  Created by surexnx on 28.04.2024.
//

import Foundation
import UIKit

final class CurrentOrdersBuilder: Builder {

    // MARK: Private properties

    private let output: OrderCurrenModuleOutput

    // MARK: Initialization

    init(output: OrderCurrenModuleOutput) {
        self.output = output
    }

    func build() -> UIViewController {
        let viewModel = OrdersCurrentViewModel(output: output, repository: OrderRepository())

        let controller = OrdersPageViewController(viewModel: viewModel)
        controller.view.tag = 0
        return controller
    }
}
