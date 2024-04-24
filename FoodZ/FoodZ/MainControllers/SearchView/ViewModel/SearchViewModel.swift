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

    private let topSection: Section
    private(set) var stateDidChange: ObservableObjectPublisher
    private let output: SearchModuleOutput
    private let remoteRepository: ProductSearchProtocol?
    private var countOffset: Int
    private var inputSearchText: String

    // MARK: Internal properties

    var sections: [Section]

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
        self.topSection = Section(id: 0, title: "", type: "topHeader", products: [])
        self.countOffset = 1
        self.inputSearchText = ""
        self.sections = []
    }

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

    private func updateSections() {
        state = .loading
        remoteRepository?.getStartRecommendations(completion: { [weak self] result in
            guard let self else { return }
            var updateSections: [Section] = []
            updateSections.append(topSection)

            switch result {
            case .success(let dispayData):
                updateSections.append(contentsOf: dispayData)
                self.state = .content(dispayData: updateSections)
            case .failure:
                state = .error(dispayData: updateSections)
            }
        })
    }

    private func proccedInputSearchText(inputText: String) {
        countOffset = 0
        sections = []
        sections.append(self.topSection)
        inputSearchText = inputText
        getSearchProducts(inputText: inputText, offset: 0)
    }

    private func proccedLazyLoad() {
        getSearchProducts(inputText: inputSearchText, offset: countOffset)
    }

    private func getSearchProducts(inputText: String, offset: Int) {
        state = .loading
        let productSearchRequest = ProductSearchRequest(searchString: inputText, limit: 5, offset: offset)
        remoteRepository?.getSearchProducts(productRequest: productSearchRequest, completion: { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let dispayData):
                sections.append(contentsOf: dispayData)
                countOffset += dispayData[0].products.count
                state = .content(dispayData: sections)
            case .failure:
                state = .error(dispayData: [topSection])
            }
        })

    }
}
