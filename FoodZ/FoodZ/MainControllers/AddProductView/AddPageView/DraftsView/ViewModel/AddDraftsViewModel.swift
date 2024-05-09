//
//  AddDraftsViewModel.swift
//  FoodZ
//
//  Created by surexnx on 04.05.2024.
//

import Foundation
import Combine

enum DraftsCellType: Hashable {
    case product(DraftsProduct)
}
protocol AddDraftsViewModeling: UIKitViewModel where State == AddDraftsState, Intent == AddDraftsIntent {}

final class AddDraftsViewModel: AddDraftsViewModeling {

    // MARK: Private properties

    private(set) var stateDidChange: ObservableObjectPublisher
    weak private var output: AddDraftsModuleOutput?
    private var repository: ProfileUserProtocol
    private let coreDataManager: CoreDataManager
    private let dataMapper: DraftsDataMapper

    // MARK: Internal properties

    @Published var state: AddDraftsState {
        didSet {
            stateDidChange.send()
        }
    }

    // MARK: Initializator

    init(output: AddDraftsModuleOutput, repository: ProfileUserProtocol, coreDataManager: CoreDataManager) {
        self.stateDidChange = ObjectWillChangePublisher()
        self.output = output
        self.repository = repository
        self.state = .loading
        self.coreDataManager = coreDataManager
        self.dataMapper = DraftsDataMapper()
    }

    // MARK: Internal methods

    func trigger(_ intent: AddDraftsIntent) {
        switch intent {
        case .onDidLoad:
            output?.addDraftsModuleDidLoad(input: self)
        case .onClose:
            break
        case .onReload:
            fetchProducts()
        case .onLoad:
            fetchProducts()
        case .proccesedTappedCell(let id):
            prossecedTappedCell(id)
        }
    }

    // MARK: Private methods

    private func prossecedTappedCell(_ id: UUID) {
        guard let product = coreDataManager.fetchCreatorByid(id: id) else { return }
        output?.proccesedTappedCell(product)
    }
    private func fetchProducts() {
        state = .loading
        state = .content(dataMapper.dispayData(from: coreDataManager.fetchProducts()))
    }
}

// MARK: - AddDraftsModuleInput

extension AddDraftsViewModel: AddDraftsModuleInput {

    func proccesedSaveProduct(product: ProductCreator) {
        coreDataManager.saveProduct(product: product)
        trigger(.onReload)
    }

    func proccesedSaveDeleteProduct(product: ProductCreator) {

    }
}
