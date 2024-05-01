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

    // MARK: Initialization

    init(output: SearchModuleOutput) {
        self.output = output
    }

    // MARK: Internal properties

    func build() -> UIViewController {
        let remoteRepository = ProductRepository()
        let viewModel = SearchViewModel(output: output, remoteRepository: remoteRepository)
        let controller = SearchViewController(viewModel: viewModel)
        return controller
    }
}
