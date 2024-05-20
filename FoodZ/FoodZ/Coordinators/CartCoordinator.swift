//
//  CartCoordinator.swift
//  FoodZ
//
//  Created by surexnx on 17.05.2024.
//

import Foundation
import UIKit

final class CartCoordinator: Coordinator {

    // MARK: Internal properties

    weak var navigationController: UINavigationController?
    weak var productInput: SelfProductModuleInput?

    // MARK: Initialization

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        start()
    }

    // MARK: Internal methods

    func start() {
        showCartView()
    }

    // MARK: Private methods

    private func showCartView() {
        let controller = CartViewBuilder(output: self).build()
        navigationController?.pushViewController(controller, animated: true)
    }

    private func showSelfProductView() {
        let controller = SelfProductBuilder(output: self).build()
        navigationController?.pushViewController(controller, animated: true)
    }

    private func popView() {
        navigationController?.popViewController(animated: false)
    }
}

// MARK: - CartModuleOutput

extension CartCoordinator: CartModuleOutput {
    func proccesedTappedProductCell(id: Int) {
        showSelfProductView()
        productInput?.proccesedSendId(id: id)
    }
}

// MARK: - SelfProductModuleOutput

extension CartCoordinator: SelfProductModuleOutput {
    func proccesedTappedButtonCart() {
        
    }
    
    func selfProductModuleDidLoad(input: SelfProductModuleInput) {
        productInput = input
    }
}
