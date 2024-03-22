//
//  AuthorizationViewModel.swift
//  Foodp2p
//
//  Created by surexnx on 21.03.2024.
//

import Combine
import UIKit

protocol AuthorizationViewModeling: UIKitViewModel where State == AuthorizationViewState, Intent == AuthorizationViewIntent {}

class AuthorizationViewModel: AuthorizationViewModeling {
    
    private(set) var stateDidChange: ObservableObjectPublisher

    @Published private(set) var state: AuthorizationViewState {
        didSet {
            stateDidChange.send()
        }
    }
    @Published var validationNotify: String = ""
    
    private var output: AuthModuleOutput?
    private var networkManager: NetworkManagerProtocol

    init(output: AuthModuleOutput, network: NetworkManagerProtocol) {
        self.stateDidChange = ObjectWillChangePublisher()
        self.state = .content("")
        self.output = output
        self.networkManager = network
    }

    func trigger(_ intent: AuthorizationViewIntent) {
        switch intent {
        case .onClose:
            break
        case .proccedButtonTapedAuthorizate(let credentials):
            guard let notify = networkManager.authenticate(credentials: credentials) else {
                output?.userAuthorizate()
                return
            }
            validationNotify = notify
        case .onReload:
            break

        case .proccedButtonTapedGoRegistrate:
            output?.presentRegistration()
        }
    }
}
