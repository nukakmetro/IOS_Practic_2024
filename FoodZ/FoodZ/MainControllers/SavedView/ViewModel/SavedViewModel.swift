//
//  SavedViewModel.swift
//  FoodZ
//
//  Created by surexnx on 03.05.2024.
//

import Foundation
import Combine

enum SavedCellType: Hashable {
    case body(Product)
}

protocol SavedViewModeling: UIKitViewModel where State == SavedState, Intent == SavedIntent {}

final class SavedViewModel: SavedViewModeling {

    // MARK: Private properties

    private(set) var stateDidChange: ObservableObjectPublisher
    private var output: SavedModuleOutput?
    private var repository: ProductRepository

    // MARK: Internal properties

    @Published var state: SavedState {
        didSet {
            stateDidChange.send()
        }
    }

    // MARK: Initializator

    init(output: SavedModuleOutput, repository: ProductRepository) {
        self.stateDidChange = ObjectWillChangePublisher()
        self.output = output
        self.state = .loading
        self.repository = repository
    }

    // MARK: Internal methods

    func trigger(_ intent: SavedIntent) {
        switch intent {
        case .onDidLoad:
            state = .loading
        case .onClose:
            break
        case .onReload:
            state = .loading
        }
    }

    // MARK: Private methods

}
