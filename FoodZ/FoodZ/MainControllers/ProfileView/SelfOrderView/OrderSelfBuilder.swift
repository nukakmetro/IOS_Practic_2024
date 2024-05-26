//
//  OrderSelfBuilder.swift
//  FoodZ
//
//  Created by surexnx on 27.05.2024.
//

import Foundation
import UIKit

final class OrderSelfBuilder: Builder {

    // MARK: Private properties

    private let output: OrderSelfModuleOutput

    // MARK: Initialization

    init(output: OrderSelfModuleOutput) {
        self.output = output
    }

    func build() -> UIViewController {
        let viewModel = OrderSelfViewModel(output: output, repository: OrderRepository())
        let controller = OrderSelfViewController(viewModel: viewModel)
        return controller
    }
}
