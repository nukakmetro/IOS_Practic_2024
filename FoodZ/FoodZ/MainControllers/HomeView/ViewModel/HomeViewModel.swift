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
    private let remoteRepository: ProductFavorietesProtocol?
    private(set) var stateDidChange: ObservableObjectPublisher

    // MARK: Internal properties

    @Published var state: HomeViewState {
        didSet {
            stateDidChange.send()
        }
    }

    // MARK: Initializator

    init(output: HomeModuleOutput, remoteRepository: ProductFavorietesProtocol) {
        self.stateDidChange = ObjectWillChangePublisher()
        self.state = .loading
        self.output = output
        self.remoteRepository = remoteRepository
        topSection = Section(id: 0, title: "hello", type: "topHeader", products: [])
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
            guard let self else { return }
            var updateSections: [Section] = []
            updateSections.append(topSection)

            switch result {
            case .success(let dispayData):
                updateSections.append(contentsOf: dispayData)
                state = .content(dispayData: updateSections)
            case .failure:
                state = .error(displayData: updateSections)
            }
        }
    )}
}
