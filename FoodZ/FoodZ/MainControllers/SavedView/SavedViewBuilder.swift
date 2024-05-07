//
//  SavedViewBuilder.swift
//  FoodZ
//
//  Created by surexnx on 04.05.2024.
//

import Foundation
import UIKit

final class SavedViewBuilder: Builder {

    // MARK: Private properties

    private let output: SavedModuleOutput

    // MARK: Initialization

    init(output: SavedModuleOutput) {
        self.output = output
    }

    // MARK: Internal properties

    func build() -> UIViewController {
        let repository = ProductRepository()
        let viewModel = SavedViewModel(output: output, repository: repository)
        let controller = SavedViewController(viewModel: viewModel)
        return controller
    }
}
