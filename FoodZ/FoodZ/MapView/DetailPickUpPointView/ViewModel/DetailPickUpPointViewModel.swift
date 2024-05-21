//
//  DetailPickUpPointViewModel.swift
//  FoodZ
//
//  Created by surexnx on 20.05.2024.
//

import Foundation
import Combine

protocol DetailPickUpPointViewModeling: UIKitViewModel where State == DetailPickUpPointState, Intent == DetailPickUpPointIntent {}

final class DetailPickUpPointViewModel: DetailPickUpPointViewModeling {

    // MARK: Private properties

    private(set) var stateDidChange: ObservableObjectPublisher
    weak private var output: DetailPickUpPointModuleOutput?
    private var repository: UserPickUpPointProtocol
    private let dataMapper: DetailPickUpPointDataMapper
    private var id: Int?

    // MARK: Internal properties

    @Published var state: DetailPickUpPointState {
        didSet {
            stateDidChange.send()
        }
    }

    // MARK: Initialization

    init(output: DetailPickUpPointModuleOutput, repository: UserPickUpPointProtocol) {
        self.stateDidChange = ObjectWillChangePublisher()
        self.output = output
        self.repository = repository
        self.state = .loading
        self.dataMapper = DetailPickUpPointDataMapper()
    }

    // MARK: Internal methods

    func trigger(_ intent: DetailPickUpPointIntent) {
        switch intent {
        case .onClose:
            break
        case .onDidLoad:
            output?.detailPickUpPointModuleDidLoad(input: self)
        case .onLoad:
            getPickUpPoint()
        case .onReload:
            break
        case .proccesedTappedButtonSelect:
            proccesedTappedButtonSelect()
        case .proccesedCloseMapModuleClose:
            output?.proccesedCloseMapModuleClose()
        }
    }

    // MARK: Private methods

    private func getPickUpPoint() {
        state = .loading
        guard let id = id else { return }
        repository.getInfoPickUpPoint(id: id) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let data):
                state = .content(displayData: dataMapper.displayData(data: data))
            case .failure:
                break
            }
        }
    }

    private func proccesedTappedButtonSelect() {
        guard let id = id else { return }
        repository.selectPickUpPoint(id: id) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success:
                trigger(.proccesedCloseMapModuleClose)
            case .failure:
                break
            }
        }
    }
}

// MARK: - DetailPickUpPointModuleInput

extension DetailPickUpPointViewModel: DetailPickUpPointModuleInput {
    func proccesDidLoad(id: Int) {
        self.id = id
        trigger(.onLoad)
    }
}
