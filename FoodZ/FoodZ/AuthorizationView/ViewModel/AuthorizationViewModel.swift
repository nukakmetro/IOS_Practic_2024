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

    // MARK: Private properties

    private(set) var stateDidChange: ObservableObjectPublisher

    @Published private(set) var state: AuthorizationViewState {
        didSet {
            stateDidChange.send()
        }
    }
    private var output: AuthModuleOutput?
    private var repository: UserAuthorizationProtocol

    // MARK: Initializator

    init(output: AuthModuleOutput, repository: UserAuthorizationProtocol) {
        self.stateDidChange = ObjectWillChangePublisher()
        self.state = .content
        self.output = output
        self.repository = repository
    }

    // MARK: Internal methods

    func trigger(_ intent: AuthorizationViewIntent) {
        switch intent {
        case .onClose:
            output?.userAuthorizate()
        case .proccedButtonTapedAuthorizate(let userRequest):
            state = .loading
            userAuthorization(userRequest)
        case .onReload:
            break
        case .proccedButtonTapedGoRegistrate:
            output?.presentRegistration()
        case .onDidLoad:
            state = .content
        }
    }

    private func userAuthorization(_ userRequest: UserRequest) {
        repository.userAuthorization(userRequest: userRequest) { [weak self] result in
            switch result {
            case .success:
                self?.trigger(.onClose)
            case .failure:
                self?.state = .error("Неправильный логин  или пароль")
            }
        }
    }
}
