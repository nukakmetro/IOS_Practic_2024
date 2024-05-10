//
//  AddMainBuilder.swift
//  FoodZ
//
//  Created by surexnx on 04.05.2024.
//

import Foundation
import UIKit

final class AddMainBuilder: Builder {

    // MARK: Private properties

    private let output: AddMainModuleOutput
    private let outputArhive: AddArhiveModuleOutput
    private let outputDrafts: AddDraftsModuleOutput

    // MARK: Initialization

    init(output: AddMainModuleOutput, outputArhive: AddArhiveModuleOutput, outputDrafts: AddDraftsModuleOutput) {
        self.output = output
        self.outputArhive = outputArhive
        self.outputDrafts = outputDrafts
    }

    // MARK: Internal properties

    func build() -> UIViewController {
        let remoteRepository = UserRepository()
        let coreDataManager = CoreDataManager()
        let viewModel = AddMainViewModel(output: output, repository: remoteRepository, coreDataManager: coreDataManager)
        let controllers = [
            AddDraftsBuilder(output: outputDrafts, coreDataManager: coreDataManager).build(),
            AddArhiveBuilder(output: outputArhive).build()
        ]
        let controller = AddMainViewController(viewModel: viewModel, viewControllers: controllers)

        return controller
    }
}
