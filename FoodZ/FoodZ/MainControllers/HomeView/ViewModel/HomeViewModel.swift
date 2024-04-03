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

    private let topSection: Section
    private let output: HomeModuleOutput
    private let networkManager: NetworkManagerProtocol
    private let localRepository: HomeLocalRepository
    private let loadRepository: HomeLoadRepository?
    @Published private(set) var sections: [Section] = []

    // MARK: Internal properties

    var stateDidChange: ObservableObjectPublisher
    var state: HomeViewState

    // MARK: Initializator

    init(output: HomeModuleOutput, network: NetworkManagerProtocol) {
        self.stateDidChange = ObjectWillChangePublisher()
        self.state = .content("")
        self.output = output
        self.networkManager = network
        self.localRepository = HomeLocalRepository()
        self.loadRepository = HomeLoadRepository()
        topSection = Section(id: 0, title: "hello", type: "topHeader", items: [])
    }

    // MARK: Internal methods

    func trigger(_ intent: HomeViewIntent) {
        switch intent {

        case .onClose: 
            break
        case .proccedButtonTapedToSearch:
            break
        case .onReload:
            updateSections()
            break
        }

    func updateSections() {
        let newSections = loadRepository?.decode() ?? []
        sections.removeAll()

        sections.append(topSection)

        sections.append(contentsOf: newSections)
//         localRepository.createSections(with: sections)
//         self.sections = localRepository.obtainSavedData()

        }
    }
}
