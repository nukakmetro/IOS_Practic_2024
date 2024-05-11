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

        case .proccedButtonTapedToSearch:
            output?.proccesedButtonTapToSearch()

        case .onReload:
            updateSections()

        case .onDidLoad:
            didLoadSections()
            trigger(.onLoad)

        case .onLoad:
            updateSections()
        }
    }

    private func didLoadSections() {
        state = .loading
        state = .content(dispayData: sections)
    }

    private func updateSections() {
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

//    private func productTappedLike(productId: Int) {
//        repository.proccesedTappedLikeButton(productId: productId) { [weak self] result in
//            guard let self else { return }
//            for sectionIndex in sections.indices {
//                if sectionIndex != 0 {
//                    sections[sectionIndex].products.forEach {
//                        if $0.productImageId == productId {
//                            sections[sectionIndex]
//                    }
//
//                    }
//                }
//            }
//
//            switch result {
//
//            case .success(let like):
//
//            case .failure(_):
//
//            }
//        }
//    }
//
//    private func changeProductLike(like: Bool, sectionIndex: Int, productIndex: Int) {
//        sections[sectionIndex].products[productIndex].productSavedStatus.s
//    }
}
