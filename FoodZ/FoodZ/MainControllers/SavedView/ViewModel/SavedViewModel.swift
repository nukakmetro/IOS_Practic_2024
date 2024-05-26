//
//  SavedViewModel.swift
//  FoodZ
//
//  Created by surexnx on 03.05.2024.
//

import Foundation
import Combine

protocol SavedViewModeling: UIKitViewModel where State == SavedState, Intent == SavedIntent {}

final class SavedViewModel: SavedViewModeling {

    // MARK: Private properties

    private(set) var stateDidChange: ObservableObjectPublisher
    private var output: SavedModuleOutput?
    private var repository: ProductSavedProtocol & ProductToggleLikeProtocol
    private var dataMapper: SavedDataMapper
    private var sections: [SavedSectionType]

    // MARK: Internal properties

    @Published var state: SavedState {
        didSet {
            stateDidChange.send()
        }
    }

    // MARK: Initializator

    init(output: SavedModuleOutput, repository: ProductSavedProtocol & ProductToggleLikeProtocol) {
        self.stateDidChange = ObjectWillChangePublisher()
        self.output = output
        self.state = .loading
        self.repository = repository
        self.dataMapper = SavedDataMapper()
        self.sections = []
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
        case .proccesedTappedLikeButton(id: let id):
            removeSaveProduct(productId: id)
        case .proccesedTappedCell(id: let id):
            output?.proccesedTappedCell(id)
        }
    }

    // MARK: Private methods

    private func getSavedProducts() {
        state = .loading
        repository.getSaveProducts { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let products):
                sections = dataMapper.displayData(products: products)
                state = .content(displayData: sections)
            case .failure:
                break
            }
        }
    }

    private func removeSaveProduct(productId: Int) {
        repository.proccesedTappedLikeButton(productId: productId) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success:
                for sectionIndex in sections.indices {
                    let section = sections[sectionIndex]
                    if case .bodySection(let id, var items) = section {
                        for itemIndex in items.indices {
                            if case .bodyCell(let product) = items[itemIndex], product.productId == productId {
                                items.remove(at: itemIndex)
                                sections[sectionIndex] = .bodySection(id, items)
                                state = .content(displayData: sections)
                                break
                            }
                        }
                    }
                }
            case .failure:
                break
            }
        }
    }
}
