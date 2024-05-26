//
//  OrdersCurrentPageViewModel.swift
//  FoodZ
//
//  Created by surexnx on 28.04.2024.
//

import Foundation
import Combine

final class OrdersCurrentViewModel: OrdersPageViewModeling {

    // MARK: Private properties

    private(set) var stateDidChange: ObservableObjectPublisher
    weak private var output: OrdersModuleOutput?
    private var repository: OrderCurrentProtocol
    private let dataMapper: OrdersPageDataMapper

    // MARK: Internal properties

    @Published var state: OrdersPageState {
        didSet {
            stateDidChange.send()
        }
    }

    // MARK: Initialization

    init(output: OrdersModuleOutput? = nil, repository: OrderCurrentProtocol) {
        self.stateDidChange = ObjectWillChangePublisher()
        self.output = output
        self.repository = repository
        self.state = .loading
        self.dataMapper = OrdersPageDataMapper()
    }

    // MARK: Internal methods

    func trigger(_ intent: OrdersPageIntent) {
        switch intent {
        case .onDidLoad:
            loadItems()
        case .onClose:
            break
        case .onReload:
            loadItems()
        }
    }

    private func loadItems() {
        state = .loading
        repository.fetchCurrentOrders { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let data):
                state = .content(dataMapper.dispayData(from: data))
            case .failure:
                break
            }
        }
    }
}
