//
//  SavedCoordinator.swift
//  FoodZ
//
//  Created by surexnx on 03.05.2024.
//

import Foundation
import UIKit

final class SavedCoordinator: Coordinator {

    // MARK: Internal properties

    weak var navigationController: UINavigationController?

    // MARK: Initializator

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        start()
    }
    // MARK: Internal methods

    func start() {
        showSavedView()
    }

    // MARK: Private methods

    private func showSavedView() {
        let controller = SavedViewBuilder(output: self).build()
        navigationController?.pushViewController(controller, animated: false)

    }

    private func popView() {
        navigationController?.popViewController(animated: false)
    }
}

// MARK: SavedModuleOutput

extension SavedCoordinator: SavedModuleOutput {

}

