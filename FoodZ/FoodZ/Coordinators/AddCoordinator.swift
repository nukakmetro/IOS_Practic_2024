//
//  AddCoordinator.swift
//  FoodZ
//
//  Created by surexnx on 05.05.2024.
//

import Foundation
import UIKit

final class AddCoordinator: Coordinator {

    // MARK: Private properties

    weak private var fillingInput: FillingModuleInput?
    weak private var mainInput: AddMainModuleInput?
    weak private var addImageInput: AddImageModuleInput?
    // MARK: Internal properties

    weak var navigationController: UINavigationController?

    // MARK: Initializator

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        start()
    }
    // MARK: Internal methods

    func start() {
        showMainView()
    }

    // MARK: Private methods

    private func showFillingView() {
        let controller = FillingBuilder(output: self).build()
        navigationController?.pushViewController(controller, animated: false)
    }

    private func showAddImageView() {
        let controller = AddImageBuilder(output: self).build()
        navigationController?.pushViewController(controller, animated: false)
    }

    private func showMainView() {
        let controller = AddMainBuilder(output: self, outputArhive: self, outputDrafts: self).build()
        navigationController?.pushViewController(controller, animated: false)
    }

    private func popView() {
        navigationController?.popViewController(animated: false)
    }

    private func popToRootView() {
        if (navigationController?.viewControllers.first) != nil {
            navigationController?.popToRootViewController(animated: true)
        }
    }
}

// MARK: - FillingModuleOutput

extension AddCoordinator: FillingModuleOutput {

    func fillingProccesedTappedSaveButton(product: ProductEntity) {
        popToRootView()
        mainInput?.proccesedSaveProduct(product: product)
    }

    func proccesedTappedNextView(product: ProductEntity) {
        showAddImageView()
        addImageInput?.addImageModuleGiveAwayProduct(product: product)
    }

    func fillingModuleDidLoad(input: FillingModuleInput) {
        fillingInput = input
    }
}

// MARK: - AddArhiveModuleOutput

extension AddCoordinator: AddArhiveModuleOutput {

}
// MARK: - AddDraftsModuleOutput

extension AddCoordinator: AddDraftsModuleOutput {

    func proccesedTappedNext(_ product: ProductEntity) {
        showFillingView()
        fillingInput?.proccesedGiveAwayProduct(product: product)
    }
}

// MARK: - AddMainModuleOutput

extension AddCoordinator: AddMainModuleOutput {

    func proccesedMainTappedCreateProduct(product: ProductEntity) {
        showFillingView()
        fillingInput?.proccesedGiveAwayProduct(product: product)
    }

    func addMainModuleDidLoad(input: AddMainModuleInput) {
        mainInput = input
    }

    func proccesedMainTappedNext(product: ProductEntity) {

    }
}

// MARK: - AddImageModuleOutput

extension AddCoordinator: AddImageModuleOutput {

    func addImageModuleDidLoad(input: AddImageModuleInput) {
        addImageInput = input
    }

    func imageProccesedTappedSaveButton(product: ProductEntity) {
        popToRootView()
        mainInput?.proccesedSaveProduct(product: product)
    }

    func proccesedCloseView(product: ProductEntity) {
        popToRootView()
        mainInput?.proccesedSaveDeleteProduct(product: product)
    }

    func proccesedTappedAddProduct() {

    }
}
