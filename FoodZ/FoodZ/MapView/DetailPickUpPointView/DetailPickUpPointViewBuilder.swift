//
//  DetailPickUpPointViewBuilder.swift
//  FoodZ
//
//  Created by surexnx on 20.05.2024.
//

import Foundation
import UIKit

final class DetailPickUpPointViewBuilder: Builder {

    // MARK: Private properties

    private let output: DetailPickUpPointModuleOutput

    // MARK: Initialization

    init(output: DetailPickUpPointModuleOutput) {
        self.output = output
    }

    // MARK: Internal properties

    func build() -> UIViewController {
        let remoteRepository = UserRepository()
        let viewModel = DetailPickUpPointViewModel(output: output, repository: remoteRepository)
        let controller = DetailPickUpPointViewController(viewModel: viewModel)
        return controller
    }
}
