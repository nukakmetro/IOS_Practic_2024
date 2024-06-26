//
//  HomeViewBuilder.swift
//  FoodZ
//
//  Created by surexnx on 31.03.2024.
//

import Foundation
import UIKit

final class HomeViewBuilder: Builder {

    // MARK: Private properties

    private let output: HomeModuleOutput

    // MARK: Initializators

    init(output: HomeModuleOutput) {
        self.output = output
    }

    // MARK: Internal properties

    func build() -> UIViewController {
        let remoteRepository = ProductRepository()
        let viewModel = HomeViewModel(output: output, remoteRepository: remoteRepository)
        let controller = HomeViewController(viewModel: viewModel)
        return controller
    }
}
