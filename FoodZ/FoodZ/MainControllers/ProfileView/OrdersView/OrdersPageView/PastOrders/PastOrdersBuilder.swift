//
//  PastOrdersBuilder.swift
//  FoodZ
//
//  Created by surexnx on 28.04.2024.
//

import Foundation
import UIKit

final class PastOrdersBuilder: Builder {
    
    func build() -> UIViewController {
        let viewModel = OrdersPastViewModel(repository: OrderRepository())
        let controller = OrdersPageViewController(viewModel: viewModel)
        controller.view.tag = 1
        return controller
    }
}
