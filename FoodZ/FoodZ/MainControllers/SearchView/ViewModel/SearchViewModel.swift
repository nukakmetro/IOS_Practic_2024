//
//  SearchViewViewModel.swift
//  FoodZ
//
//  Created by surexnx on 03.04.2024.
//

import Foundation
import Combine

enum SearchCellType: Hashable {
    case header
    case body(Product)
}

enum SearchSomeSection: Hashable {
    case header([SearchCellType])
    case body([SearchCellType])
}

protocol SearchViewModeling: UIKitViewModel where State == SearchViewState, Intent == SearchViewIntent {}

final class SearchViewModel: SearchViewModeling {

    // MARK: Private properties

    private(set) var stateDidChange: ObservableObjectPublisher
    private let output: SearchModuleOutput
    private let remoteRepository: ProductSearchProtocol
    private var countOffset: Int
    private var inputSearchText: String
    private var sections: [SearchSomeSection]

    // MARK: Internal properties

    @Published var state: SearchViewState {
        didSet {
            stateDidChange.send()
        }
    }

    // MARK: Initialization

    init(output: SearchModuleOutput, remoteRepository: ProductSearchProtocol) {
        self.stateDidChange = ObservableObjectPublisher()
        self.output = output
        self.state = .loading
        self.remoteRepository = remoteRepository
        self.countOffset = 0
        self.inputSearchText = ""
        sections = []
        sections.append(.header([.header]))
    }

    // MARK: Internal methods

    func trigger(_ intent: SearchViewIntent) {
        switch intent {
        case .onClose:
            output.moduleWantsToClose()
        case .onReload:
            updateSections()
        case .proccesedInputSearchText(let inputText):
            proccedInputSearchText(inputText: inputText)
        case .onDidlLoad:
            updateSections()
        case .proccesedLazyLoad:
            proccedLazyLoad()
        }
    }

    // MARK: Private methods

    private func updateSections() {
        sections = sections.filter { $0 == sections.first }
        state = .loading
        remoteRepository.getStartRecommendations(completion: { [weak self] result in
            guard let self else { return }

            switch result {
            case .success(let dispayData):
                var updateSection: [SearchCellType] = []
                for data in dispayData {
                    updateSection.append(.body(data))
                }
                sections.append(.body(updateSection))
                state = .content(dispayData: sections)
            case .failure:
                state = .error
            }
        })
    }

    private func proccedInputSearchText(inputText: String) {
        sections = sections.filter { $0 == sections.first }
        countOffset = 0
        inputSearchText = inputText
        getSearchProducts(inputText: inputText, offset: 0)
    }

    private func proccedLazyLoad() {
        getSearchProducts(inputText: inputSearchText, offset: countOffset)
    }

    private func getSearchProducts(inputText: String, offset: Int) {
        state = .loading
        let productSearchRequest = ProductSearchRequest(searchString: inputText, limit: 5, offset: offset)

        remoteRepository.getSearchProducts(productRequest: productSearchRequest, completion: { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let dispayData):
                var updateSection: [SearchCellType] = []
                for data in dispayData {
                    updateSection.append(.body(data))
                }
                sections.append(.body(updateSection))
                countOffset += 1
                self.state = .content(dispayData: sections)
            case .failure:
                state = .error
            }
        })
    }
}
