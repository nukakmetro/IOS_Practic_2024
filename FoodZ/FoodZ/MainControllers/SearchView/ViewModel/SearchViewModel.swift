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

    private(set) var stateDidChange: ObservableObjectPublisher
    private let output: SearchModuleOutput
    private let remoteRepository: ProductSearchProtocol
    private var countOffset: Int
    private var inputSearchText: String
    private var sections: [SearchSectionType]
    private var dataMapper: SearchDataMapper

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
        self.remoteRepository = remoteRepository
        self.countOffset = 0
        self.inputSearchText = ""
        self.dataMapper = SearchDataMapper()
        sections = []
        sections.append(.headerSection(UUID(), .header))
        self.state = .content(dispayData: sections)
    }

    // MARK: Internal methods

    func trigger(_ intent: SearchViewIntent) {
        switch intent {
        case .onClose:
            output.moduleWantsToClose()
        case .onReload:
            updateSections()
        case .proccesedInputSearchText(let inputText):
            if let inputText = inputText {
                proccedInputSearchText(inputText: inputText)
            } else {
                trigger(.onReload)
            }
        case .onDidlLoad:
            updateSections()
        case .proccesedLazyLoad:
            proccedLazyLoad()
        case .proccesedTappedCell(let id):
            output.proccesedTappedCell(id)
        }
    }

    // MARK: Private methods

    private func updateSections() {
        sections = sections.filter { $0 == sections.first }
        state = .loading
        remoteRepository.getStartRecommendations(completion: { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let products):
                sections.append(contentsOf: dataMapper.displayData(products: products))
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
            case .success(let products):
                sections.append(contentsOf: dataMapper.displayData(products: products))
                countOffset += 1
                self.state = .content(dispayData: sections)
            case .failure:
                state = .error
            }
        })
    }
}
