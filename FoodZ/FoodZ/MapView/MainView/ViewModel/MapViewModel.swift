//
//  MapViewModel.swift
//  FoodZ
//
//  Created by surexnx on 20.05.2024.
//

import Foundation
import Combine

protocol MapViewModeling: UIKitViewModel where State == MapViewState, Intent == MapViewIntent {}

final class MapViewModel: MapViewModeling {

    // MARK: Private properties

    private(set) var stateDidChange: ObservableObjectPublisher
    weak private var output: MapModuleOutput?
    private var repository: PickUpPointProtocol
    private let dataMapper: MapViewDataMapper

    // MARK: Internal properties

    @Published var state: MapViewState {
        didSet {
            stateDidChange.send()
        }
    }

    // MARK: Initialization

    init(output: MapModuleOutput, repository: PickUpPointProtocol) {
        self.stateDidChange = ObjectWillChangePublisher()
        self.output = output
        self.repository = repository
        self.state = .loading
        self.dataMapper = MapViewDataMapper()
    }

    // MARK: Internal methods

    func trigger(_ intent: MapViewIntent) {
        switch intent {

        case .onClose:
            break
        case .onDidLoad:
            getAllPickUpPoint()
        case .onLoad:
            break
        case .onReload:
            break
        case .proccesedTappedAnnotation(let pickUpPointId):
            output?.proccesedTappedAnnotation(pickUpPointId: pickUpPointId)
        }
    }

    // MARK: Private methods

    private func getAllPickUpPoint() {
        state = .loading
        repository.getAllPickUpPoint { [weak self] result in
            guard let self = self else { return }
            switch result {

            case .success(let data):
                let displayData = dataMapper.displayData(data: data)
                state = .content(displayData: displayData)
            case .failure:
                break
            }
        }
    }
}

