//
//  SearchViewViewModel.swift
//  FoodZ
//
//  Created by surexnx on 03.04.2024.
//

import Foundation
import Combine

protocol SearchViewModeling: DisplayDataProtocol, UIKitViewModel where State == SearchViewState, Intent == SearchViewIntent {}

final class SearchViewModel<RemoteRepository: ProductSearchProtocol>: SearchViewModeling {

    // MARK: Private properties

    private let topSection: Section
    private(set) var stateDidChange: ObservableObjectPublisher
    private let output: SearchModuleOutput
    private var networkManager: NetworkManagerProtocol
    private let remoteRepository: RemoteRepository?
    @Published private(set) var sections: [Section] = [] {
        didSet {
            sectionsDidChange.send(sections)
        }
    }
    private(set) var sectionsDidChange: PassthroughSubject<[Section], Never>

    // MARK: Internal properties

    var state: SearchViewState

    init(output: SearchModuleOutput, networkManager: NetworkManagerProtocol, remoteRepository: RemoteRepository) {
        self.stateDidChange = ObservableObjectPublisher()
        self.output = output
        self.state = SearchViewState.error
        self.remoteRepository = remoteRepository
        self.networkManager = networkManager
        self.sectionsDidChange = PassthroughSubject<[Section], Never>()
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
        }
    }

    private func updateSections() {
        let newSections = remoteRepository?.getStartRecommendations() ?? []
        sections.removeAll()

        sections.append(topSection)

        sections.append(contentsOf: newSections)
    }

    private func proccedInputSearchText(inputText: String) {
        let newSections = remoteRepository?.getSearchProducts(inputText) ?? []
        sections.removeAll()

        sections.append(topSection)

        sections.append(contentsOf: newSections)
    }
}
