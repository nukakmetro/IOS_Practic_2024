//
//  AddDraftsBuilder.swift
//  FoodZ
//
//  Created by surexnx on 04.05.2024.
//

import Foundation
import UIKit

final class AddDraftsBuilder: Builder {

    // MARK: Private properties

    private let output: AddDraftsModuleOutput
    private let coreDataManager: CoreDataManager

    // MARK: Initialization

    init(output: AddDraftsModuleOutput, coreDataManager: CoreDataManager) {
        self.output = output
        self.coreDataManager = coreDataManager
    }

    // MARK: Internal properties

    func build() -> UIViewController {
        let repository = UserRepository()
        let viewModel = AddDraftsViewModel(output: output, repository: repository, coreDataManager: coreDataManager)
        let controller = AddDraftsViewController(viewModel: viewModel)
        return controller
    }
}
