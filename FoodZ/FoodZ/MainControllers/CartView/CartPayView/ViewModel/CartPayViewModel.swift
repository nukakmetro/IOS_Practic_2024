//
//  CartPayViewModel.swift
//  FoodZ
//
//  Created by surexnx on 19.05.2024.
//

import Foundation
import Combine

protocol CartPayViewModeling: UIKitViewModel where State == CartPayState, Intent == CartPayIntent {}

final class CartPayViewModel: CartPayViewModeling {

    // MARK: Private properties

    private var output: CartPayModuleOutput?
    private let repository: CartPayProtocol
    private(set) var stateDidChange: ObservableObjectPublisher
    private var sections: [CartSectionType]
    private let dataMapper: CartPayDataMapper
    private var viewData: CartViewData

    // MARK: Internal properties

    @Published var state: CartPayState {
        didSet {
            stateDidChange.send()
        }
    }

    // MARK: Initialization

    init(output: CartPayModuleOutput, remoteRepository: CartPayProtocol) {
        self.stateDidChange = ObjectWillChangePublisher()
        self.state = .loading
        self.output = output
        self.repository = remoteRepository
        self.sections = []
        self.dataMapper = CartPayDataMapper()
        self.viewData = CartViewData(totalPrice: 0)
    }

    // MARK: Internal methods

    func trigger(_ intent: CartPayIntent) {
        switch intent {

        case .onClose:
            output?.proccesedTappedButtonClose()
        case .onDidLoad:
            getCarts()
        case .onLoad:
            break
        case .onReload:
            break
        case .proccesedTappedButtonPay:
            break
        }
    }

    private func getCarts() {
        state = .loading
        repository.getCartPay { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let data):
                state = .content(displayData: dataMapper.displayData(data: data), totalPrice: String(data.totalPrice))
            case .failure:
                break
            }
        }
    }
}

