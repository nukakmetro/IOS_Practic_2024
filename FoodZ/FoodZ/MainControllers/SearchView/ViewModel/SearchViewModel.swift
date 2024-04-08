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
    private var networkManager: NetworkManagerProtocol
    private let remoteRepository: ProductSearchProtocol?
    private let localRepository: HomeLocalRepository

    // MARK: Internal properties

    @Published var state: SearchViewState {
        didSet {
            stateDidChange.send()
        }
    }

    // MARK: Initializator

    init(output: SearchModuleOutput, networkManager: NetworkManagerProtocol, remoteRepository: ProductSearchProtocol) {
        self.stateDidChange = ObservableObjectPublisher()
        self.output = output      
        self.state = .loading
        self.state = SearchViewState.error
        self.remoteRepository = remoteRepository
        self.networkManager = networkManager
        self.localRepository = HomeLocalRepository()
        self.topSection = Section(id: 0, title: "", type: "topHeader", items: [])
    }

    func trigger(_ intent: SearchViewIntent) {
        switch intent {
        case .onClose:
            output.moduleWantsToClose()
        case .onReload:
            updateSections()
        case .proccedInputSearchText(let inputText):
            proccedInputSearchText(inputText: inputText)

        case .onDidlLoad:
            updateSections()
        }
    }

    private func updateSections() {
        state = .loading
        remoteRepository?.getStartRecommendations(completion: { [weak self] result in
            switch result {
            case .success(let dispayData):
                guard let self else { return }
                var updateSections: [Section] = []
                updateSections.append(self.topSection)
                updateSections.append(contentsOf: dispayData)
                self.state = .content(dispayData: updateSections)
            case .failure:
                self?.state = .error
            }
        })
    }

    private func proccedInputSearchText(inputText: String) {
        state = .loading
        remoteRepository?.getSearchProducts(inputText: inputText, completion: { [weak self] result in
            switch result {
            case .success(let dispayData):
                guard let self else { return }
                var updateSections: [Section] = []
                updateSections.append(self.topSection)
                updateSections.append(contentsOf: dispayData)
                self.state = .content(dispayData: updateSections)
            case .failure:
                self?.state = .error
            }
        })
    }
}
