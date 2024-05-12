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

    // MARK: Initializator

    init(output: HomeModuleOutput, remoteRepository: ProductFavorietesProtocol & ProductToggleLikeProtocol) {
        self.stateDidChange = ObjectWillChangePublisher()
        self.state = .loading
        self.output = output
        self.repository = remoteRepository
        self.sections = []
        self.sections.append(.headerSection(.headerCell))
        self.dataMapper = HomeDataMapper()
    }

    // MARK: Internal methods

    func trigger(_ intent: HomeViewIntent) {
        switch intent {
        case .onClose: break

        case .proccesedTappedButtonSearch:
            output?.proccesedButtonTapToSearch()

        case .onReload:
            updateSections()

        case .onDidLoad:
            didLoadSections()
            trigger(.onLoad)

        case .onLoad:
            updateSections()

        case .proccesedTappedLikeButton(id: let id):
            productTappedLike(productId: id)
        }
    }

    private func didLoadSections() {
        state = .loading
        state = .content(dispayData: sections)
    }

    private func updateSections() {
        sections = sections.filter { $0 == sections.first }
        state = .loading
        repository.getFavoritesProducts(completion: { [weak self] result in
            guard let self else { return }

            switch result {
            case .success(let dispayData):
                sections.insert(contentsOf: dataMapper.displayData(sections: dispayData), at: 1)
                state = .content(dispayData: sections)

            case .failure:
                state = .error(displayData: sections)
            }
        }
        )
    }

    private func productTappedLike(productId: Int) {
        state = .loading

        repository.proccesedTappedLikeButton(productId: productId) { [weak self] result in
            guard let self else { return }

            switch result {

            case .success(let like):
                changeProductLike(like: like, id: productId)
                state = .content(dispayData: sections)
            case .failure:
                break
            }
        }
    }

    private func changeProductLike(like: Bool, id: Int) {

        for sectionIndex in sections.indices {

            var section = sections[sectionIndex]

            if case .bodySection(var products) = section {

                for productIndex in products.indices {

                    if 
                        case .bodyCell(var product) = products[productIndex],
                        product.productId == id 
                    {

                        product.productSavedStatus = like
                        products[productIndex] = .bodyCell(product)
                        sections[sectionIndex] = .bodySection(products)
                    }
                }
            }
        }
    }
}
