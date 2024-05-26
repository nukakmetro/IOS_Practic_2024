//
//  HomeViewModel.swift
//  FoodZ
//
//  Created by surexnx on 26.03.2024.
//

import Foundation
import Combine

protocol HomeViewModeling: UIKitViewModel where State == HomeViewState, Intent == HomeViewIntent {}

final class HomeViewModel: HomeViewModeling {

    // MARK: Private properties

    private var output: HomeModuleOutput?
    private let repository: ProductFavorietesProtocol & ProductToggleLikeProtocol
    private(set) var stateDidChange: ObservableObjectPublisher
    private var sections: [HomeSectionType]
    private let dataMapper: HomeDataMapper

    // MARK: Internal properties

    @Published var state: HomeViewState {
        didSet {
            stateDidChange.send()
        }
    }

    // MARK: Initialization

    init(output: HomeModuleOutput, remoteRepository: ProductFavorietesProtocol & ProductToggleLikeProtocol) {
        self.stateDidChange = ObjectWillChangePublisher()
        self.state = .loading
        self.output = output
        self.repository = remoteRepository
        self.sections = []
        self.sections.append(.headerSection(id: UUID(), .headerCell))
        self.dataMapper = HomeDataMapper()
    }

    // MARK: Internal methods

    func trigger(_ intent: HomeViewIntent) {
        switch intent {
        case .onClose: break

        case .proccesedTappedButtonSearch:
            output?.proccesedTappedButtonSearch()

        case .onReload:
            updateSections()

        case .onDidLoad:
            didLoadSections()
            trigger(.onLoad)

        case .onLoad:
            updateSections()

        case .proccesedTappedLikeButton(let id):
            productTappedLike(productId: id)

        case .proccesedTappedCell(let id):
            output?.proccesedTappedProductCell(id: id)
        }
    }

    private func didLoadSections() {
        state = .loading
        state = .content(displayData: sections)
    }

    private func updateSections() {
        sections = sections.filter { $0 == sections.first }
        state = .loading
        repository.getFavoritesProducts(completion: { [weak self] result in
            guard let self else { return }

            switch result {
            case .success(let dispayData):
                sections.insert(contentsOf: dataMapper.displayData(sections: dispayData), at: 1)
                state = .content(displayData: sections)

            case .failure:
                state = .error(displayData: sections)
            }
        })
    }

    private func productTappedLike(productId: Int) {
        state = .loading

        repository.proccesedTappedLikeButton(productId: productId) { [weak self] result in
            guard let self else { return }

            switch result {
            case .success(let like):
                for sectionIndex in sections.indices {
                    let section = sections[sectionIndex]
                    if case .bodySection(let id, var items) = section {
                        for itemIndex in items.indices {
                            if case .bodyCell(let product) = items[itemIndex], product.productId == productId {
                                var newProduct = product
                                newProduct.id = UUID()
                                newProduct.productSavedStatus = like
                                items[itemIndex] = .bodyCell(newProduct)
                                sections[sectionIndex] = .bodySection(id: id, items)
                                state = .content(displayData: sections)
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
