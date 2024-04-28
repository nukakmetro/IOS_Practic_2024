//
//  CurrentOrdersBuilder.swift
//  FoodZ
//
//  Created by surexnx on 28.04.2024.
//

import Foundation
import UIKit

final class CurrentOrdersBuilder: Builder {

    func build() -> UIViewController {
        let viewModel = OrdersCurrentViewModel(repository: OrderRepository())

        let controller = OrdersPageViewController(viewModel: viewModel)
        controller.view.tag = 0
        return controller
    }
}
