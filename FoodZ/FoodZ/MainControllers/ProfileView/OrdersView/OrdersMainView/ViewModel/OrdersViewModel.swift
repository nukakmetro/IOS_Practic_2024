//
//  OrdersViewModel.swift
//  FoodZ
//
//  Created by surexnx on 27.04.2024.
//

import Foundation
import Combine

protocol OrdersViewModeling: UIKitViewModel where State == OrdersState, Intent == OrdersIntent {}

final class OrdersViewModel: OrdersViewModeling {

    // MARK: Private properties

    private(set) var stateDidChange: ObservableObjectPublisher
    weak private var output: OrdersModuleOutput?
    private var repository: ProfileUserProtocol

    // MARK: Internal properties

    @Published var state: OrdersState {
        didSet {
            stateDidChange.send()
        }
    }

    // MARK: Initializator

    init(output: OrdersModuleOutput? = nil, repository: ProfileUserProtocol) {
        self.stateDidChange = ObjectWillChangePublisher()
        self.output = output
        self.repository = repository
        self.state = .loading
    }

    // MARK: Internal methods

    func trigger(_ intent: OrdersIntent) {
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
