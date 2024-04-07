//
//  SearchViewBuilder.swift
//  FoodZ
//
//  Created by surexnx on 07.04.2024.
//

import Foundation
import UIKit

final class SearchViewBuilder: Builder {

    // MARK: Private properties

    private let output: SearchModuleOutput

    // MARK: Initializators

    init(output: SearchModuleOutput) {
        self.output = output
    }

    // MARK: Internal properties

    func build() -> UIViewController {
        let networkManager = MockNetworkManager()
        let remoteRepository = ProductRemoteRepository()
        let viewModel = SearchViewModel(output: output, networkManager: networkManager, remoteRepository: remoteRepository)
        let controller = SearchViewController(viewModel: viewModel)
        return controller
    }
}
