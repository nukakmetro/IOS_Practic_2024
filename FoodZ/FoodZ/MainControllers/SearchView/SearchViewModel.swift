//
//  SearchViewViewModel.swift
//  FoodZ
//
//  Created by surexnx on 03.04.2024.
//

import Foundation
import Combine

protocol SearchViewModeling: UIKitViewModel where State == SearchViewState, Intent == SearchViewIntent {}

final class SearchViewModel: SearchViewModeling {

    // MARK: Private properties
    var stateDidChange: ObservableObjectPublisher
    private let output: SearchModuleOutput
    var state: SearchViewState
    var networkManager: NetworkManagerProtocol

    init(output: SearchModuleOutput, networkManager: NetworkManagerProtocol) {
        self.stateDidChange = ObservableObjectPublisher()
        self.output = output
        self.state = SearchViewState.error
        self.networkManager = networkManager
    }

    func trigger(_ intent: SearchViewIntent) {

    }
}
