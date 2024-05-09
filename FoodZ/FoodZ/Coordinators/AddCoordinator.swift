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
    weak private var addDraftsInput: AddDraftsModuleInput?
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

    func fillingProccesedTappedSaveButton(product: ProductCreator) {
        addDraftsInput?.proccesedSaveProduct(product: product)
        popToRootView()
    }

    func proccesedTappedNextView(product: ProductCreator) {
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

    func addDraftsModuleDidLoad(input: AddDraftsModuleInput) {
        addDraftsInput = input
    }

    func proccesedTappedNext(_ product: ProductCreator) {
        showFillingView()
        fillingInput?.proccesedGiveAwayProduct(product: product)
    }
}

// MARK: - AddMainModuleOutput

extension AddCoordinator: AddMainModuleOutput {

    func proccesedMainTappedCreateProduct(product: ProductCreator) {
        showFillingView()
        fillingInput?.proccesedGiveAwayProduct(product: product)
    }

    func proccesedMainTappedNext(product: ProductEntity) {

    }
}

// MARK: - AddImageModuleOutput

extension AddCoordinator: AddImageModuleOutput {

    func addImageModuleDidLoad(input: AddImageModuleInput) {
        addImageInput = input
    }

    func imageProccesedTappedSaveButton(product: ProductCreator) {
        popToRootView()
        addDraftsInput?.proccesedSaveProduct(product: product)
    }

    func proccesedCloseView(product: ProductCreator) {
        popToRootView()
        addDraftsInput?.proccesedSaveDeleteProduct(product: product)
    }

    func proccesedTappedAddProduct() {

    }
}
