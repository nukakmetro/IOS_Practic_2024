//
//  RegistrationViewModel.swift
//  Foodp2p
//
//  Created by surexnx on 20.03.2024.
//

import Foundation
import Combine

protocol RegistrationViewModeling: UIKitViewModel where State == RegistrationViewState, Intent == RegistrationViewIntent {}

final class RegistrationViewModel: RegistrationViewModeling {

    // MARK: Private properties

    private weak var output: RegModuleOutput?
    private let repository: UserRegistrationProtocol
    private(set) var stateDidChange: ObservableObjectPublisher
    @Published private(set) var state: RegistrationViewState {
        didSet {
            stateDidChange.send()
        }
    }

    // MARK: Initializator

    init(output: RegModuleOutput, repository: UserRegistrationProtocol) {
        self.stateDidChange = ObjectWillChangePublisher()
        self.state = .content
        self.output = output
        self.repository = repository
    }

    // MARK: Internal methods

    func trigger(_ intent: RegistrationViewIntent) {
        switch intent {
        case .onClose:
            output?.presentAuthorization()
        case .proccedButtonTapedRegistrate(let userRegistrationRequest):
            state = .loading
            userRegistration(userRegistrationRequest)
        case .onDidLoad:
            state = .content
        case .proccedButtonTapedGoToAuth:
            output?.presentAuthorization()
        }
    }

    // MARK: Private methods

    private func userRegistration(_ userRegistrationRequst: UserRegistrationRequest) {
        if userRegistrationRequst.userPasswordComparison() {
            repository.userRegistration(userRegistrationRequest: userRegistrationRequst) { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success:
                    trigger(.onClose)
                case .failure(_):
                    state = .error("Некоректные данные")
                }
            }
        } else {
            state = .error("Пароли не совпадают")
        }
    }
}
