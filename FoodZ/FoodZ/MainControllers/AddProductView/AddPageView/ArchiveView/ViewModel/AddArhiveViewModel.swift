//
//  AddArhiveViewModel.swift
//  FoodZ
//
//  Created by surexnx on 04.05.2024.
//

import Foundation
import Combine

protocol AddArhiveViewModeling: UIKitViewModel where State == AddArhiveState, Intent == AddArhiveIntent {}

final class AddArhiveViewModel: AddArhiveViewModeling {

    // MARK: Private properties

    private(set) var stateDidChange: ObservableObjectPublisher
    weak private var output: AddArhiveModuleOutput?
    private var repository: ProfileUserProtocol

    // MARK: Internal properties

    @Published var state: AddArhiveState {
        didSet {
            stateDidChange.send()
        }
    }

    // MARK: Initializator

    init(output: AddArhiveModuleOutput, repository: ProfileUserProtocol) {
        self.stateDidChange = ObjectWillChangePublisher()
        self.output = output
        self.repository = repository
        self.state = .loading
    }

    // MARK: Internal methods

    func trigger(_ intent: AddArhiveIntent) {
        switch intent {
        case .onDidLoad:
            break
        case .onClose:
            break
        case .onReload:
            break
        }
    }
}
