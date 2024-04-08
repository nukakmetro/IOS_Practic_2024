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
    private var output: HomeModuleOutput?
    private let networkManager: NetworkManagerProtocol
    private let localRepository: HomeLocalRepository
    private let remoteRepository: ProductFavorietesProtocol?
    private(set) var stateDidChange: ObservableObjectPublisher

    // MARK: Internal properties

    @Published var state: HomeViewState {
        didSet {
            stateDidChange.send()
        }
    }

    // MARK: Initializator

    init(output: HomeModuleOutput, networkManager: NetworkManagerProtocol, remoteRepository: ProductFavorietesProtocol) {
        self.stateDidChange = ObjectWillChangePublisher()
        self.state = .loading
        self.output = output
        self.networkManager = networkManager
        self.localRepository = HomeLocalRepository()
        self.remoteRepository = remoteRepository
        topSection = Section(id: 0, title: "hello", type: "topHeader", items: [])
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
            updateSections()

        }
    }

    func updateSections() {
        state = .loading
        remoteRepository?.getFavoritesProducts(completion: { [weak self] result in
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
        }
    )}
}
