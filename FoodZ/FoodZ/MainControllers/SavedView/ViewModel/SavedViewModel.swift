//
//  SavedViewModel.swift
//  FoodZ
//
//  Created by surexnx on 03.05.2024.
//

import Foundation
import Combine

enum SavedSectionType: Hashable {
    case bodySection([SavedCellType])
}

enum SavedCellType: Hashable {
    case bodyCell(ProductCell)
}

protocol SavedViewModeling: UIKitViewModel where State == SavedState, Intent == SavedIntent {}

final class SavedViewModel: SavedViewModeling {

    // MARK: Private properties

    private(set) var stateDidChange: ObservableObjectPublisher
    private var output: SavedModuleOutput?
    private var repository: ProductSavedProtocol
    private var dataMapper: SavedDataMapper

    // MARK: Internal properties

    @Published var state: SavedState {
        didSet {
            stateDidChange.send()
        }
    }

    // MARK: Initializator

    init(output: SavedModuleOutput, repository: ProductSavedProtocol) {
        self.stateDidChange = ObjectWillChangePublisher()
        self.output = output
        self.state = .loading
        self.repository = repository
        self.dataMapper = SavedDataMapper()
    }

    // MARK: Internal methods

    func trigger(_ intent: SavedIntent) {
        switch intent {
        case .onDidLoad:
            getSavedProducts()
        case .onClose:
            break
        case .onReload:
            getSavedProducts()
        }
    }

    // MARK: Private methods

    private func getSavedProducts() {
        state = .loading
        repository.getSaveProducts { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let products):
                var sections: [SavedSectionType] = []
                sections.append(.bodySection(dataMapper.displayData(products: products)))
                state = .content(displaydata: sections)
            case .failure:
                break
            }
        }
    }
}
