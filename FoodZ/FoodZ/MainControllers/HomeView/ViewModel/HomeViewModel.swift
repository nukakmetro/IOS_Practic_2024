//
//  HomeViewModel.swift
//  FoodZ
//
//  Created by surexnx on 26.03.2024.
//

import Foundation
import Combine

protocol HomeViewModeling: DisplayDataProtocol, UIKitViewModel where State == HomeViewState, Intent == HomeViewIntent {}

final class HomeViewModel<RemoteRepository: ProductFavorietesProtocol>: HomeViewModeling {

    // MARK: Private properties

    private let topSection: Section
    private var output: HomeModuleOutput?
    private let networkManager: NetworkManagerProtocol
    private let localRepository: HomeLocalRepository
    private let remoteRepository: RemoteRepository?
    private(set) var sectionsDidChange: PassthroughSubject<[Section], Never>

    @Published private(set) var sections: [Section] = [] {
        didSet {
            sectionsDidChange.send(sections)
        }
    }

    // MARK: Internal properties

    var stateDidChange: ObservableObjectPublisher
    var state: HomeViewState

    // MARK: Initializator

    init(output: HomeModuleOutput, network: NetworkManagerProtocol, remoteRepository: RemoteRepository) {
        self.stateDidChange = ObjectWillChangePublisher()
        self.state = .content("")
        self.output = output
        self.networkManager = network
        self.localRepository = HomeLocalRepository()
        self.remoteRepository = remoteRepository
        topSection = Section(id: 0, title: "hello", type: "topHeader", items: [])
        self.sectionsDidChange = PassthroughSubject<[Section], Never>()
    }

    // MARK: Internal methods

    func trigger(_ intent: HomeViewIntent) {
        switch intent {
        case .onClose: break
        case .proccedButtonTapedToSearch:
            output?.proccesedButtonTapToSearch()
        case .onReload:
            updateSections()
        }
    }

    func updateSections() {
        let newSections = remoteRepository?.getFavoritesProducts() ?? []
        sections.removeAll()

        sections.append(topSection)

        sections.append(contentsOf: newSections)
//         localRepository.createSections(with: sections)
//         self.sections = localRepository.obtainSavedData()

    }
}
