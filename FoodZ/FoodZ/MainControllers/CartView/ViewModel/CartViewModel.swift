//
//  CartViewModel.swift
//  FoodZ
//
//  Created by surexnx on 17.05.2024.
//

import Foundation
import Combine

protocol CartViewModelDelegate: AnyObject {
    func proccesedRemoveCartItem(id: Int)
}

protocol CartViewModeling: UIKitViewModel where State == CartViewState, Intent == CartViewIntent {
    var delegate: CartViewModelDelegate? { get set }
}

final class CartViewModel: CartViewModeling {

    // MARK: Private properties
    private var output: CartModuleOutput?
    private let repository: CartProtocol
    private(set) var stateDidChange: ObservableObjectPublisher
    private var sections: [CartSectionType]
    private let dataMapper: CartDataMapper

    // MARK: Internal properties

    weak var delegate: CartViewModelDelegate?

    @Published var state: CartViewState {
        didSet {
            stateDidChange.send()
        }
    }

    // MARK: Initializator

    init(output: CartModuleOutput, remoteRepository: CartProtocol) {
        self.stateDidChange = ObjectWillChangePublisher()
        self.state = .loading
        self.output = output
        self.repository = remoteRepository
        self.sections = []
        self.dataMapper = CartDataMapper()
    }

    // MARK: Internal methods

    func trigger(_ intent: CartViewIntent) {
        switch intent {
        case .onClose:
            break
        case .onDidLoad:
            getCart()
        case .onLoad:
            break
        case .onReload:
            getCart()
        case .proccesedTappedButtonReduce(let id, let inputCell):
            reduceCartItem(cartId: id, inputCell: inputCell)
        case .proccesedTappedButtonIncrease(let id, let inputCell):
            increaseCartItem(cartId: id, inputCell: inputCell)
        case .proccesedTappedButtonTrash(let id):
            removeCartItem(cartId: id)
        case .proccesedTappedButtonCell(let id):
            output?.proccesedTappedProductCell(id: id)
        }
    }

    private func getCart() {
        state = .loading
        repository.getCart { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let data):
                sections = dataMapper.displayData(data: data)
                state = .content(displayData: sections)
            case .failure:
                break
            }
        }
    }

    private func increaseCartItem(cartId: Int, inputCell: CartCellInput) {
        repository.increaseCart(cartId: cartId) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let data):
                inputCell.proccesedTappedButtonIncrease(quantity: String(data.cartItemQuantity), price: String(data.cartItemPrice))
            case .failure:
                break
            }
        }
    }

    private func reduceCartItem(cartId: Int, inputCell: CartCellInput) {
        repository.reduceCart(cartId: cartId) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let data):
                inputCell.proccesedTappedButtonReduce(quantity: String(data.cartItemQuantity), price: String(data.cartItemPrice))
            case .failure:
                break
            }
        }
    }

    private func removeCartItem(cartId: Int) {
        repository.removeCart(cartId: cartId) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success: break
                for sectionIndex in sections.indices {
                    var section = sections[sectionIndex]
                    if case .bodySection(var items) = section {
                        for itemIndex in items.indices {
                            if case .bodyICell(var cart) = items[itemIndex],
                                cart.cartItemId == cartId {
                                items.remove(at: itemIndex)
                                sections[sectionIndex] = .bodySection(items)
                            }
                        }
                    }
                }
                state = .content(displayData: sections)
            case .failure:
                break
            }
        }
    }
}

