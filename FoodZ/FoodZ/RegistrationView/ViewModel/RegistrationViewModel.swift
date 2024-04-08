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
    private var networkManager: NetworkManagerProtocol
    private(set) var stateDidChange: ObservableObjectPublisher
    @Published private(set) var state: RegistrationViewState {
        didSet {
            stateDidChange.send()
        }
    }
    @Published private(set) var validationNotify: String?

    // MARK: Initializator

    init(output: RegModuleOutput, network: NetworkManagerProtocol) {
        self.stateDidChange = ObjectWillChangePublisher()
        self.state = .content("")
        self.output = output
        self.networkManager = network
    }

    // MARK: Internal methods

    func trigger(_ intent: RegistrationViewIntent) {
        switch intent {
        case .onClose:
            break
        case .proccedButtonTapedRegistrate(let credentials):
            guard let notify = networkManager.registration(credentials: credentials) else {
                output?.presentAuthorization()
                return
            }
            validationNotify = notify

        case .onReload:
            break

        case .proccedButtonTapedGoToAuth:
            output?.presentAuthorization()
        }
    }
}
