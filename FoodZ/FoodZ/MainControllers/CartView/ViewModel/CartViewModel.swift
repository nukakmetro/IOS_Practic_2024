//
//  CartViewModel.swift
//  FoodZ
//
//  Created by surexnx on 17.05.2024.
//

import Foundation
import Combine

protocol CartViewModeling: UIKitViewModel where State == CartViewState, Intent == CartViewIntent {}

final class CartViewModel: CartViewModeling {

    // MARK: Private properties

    private var output: CartModuleOutput?
    private let repository: CartProtocol
    private(set) var stateDidChange: ObservableObjectPublisher
    private var sections: [CartSectionType]
    private let dataMapper: CartDataMapper

    // MARK: Internal properties

    @Published var state: CartViewState {
        didSet {
            stateDidChange.send()
        }
    }

    // MARK: Initialization

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
        case .proccesedTappedButtonReduce(let id):
            reduceCartItem(cartItemId: id)
        case .proccesedTappedButtonIncrease(let id):
            increaseCartItem(cartItemId: id)
        case .proccesedTappedButtonTrash(let id):
            removeCartItem(cartItemId: id)
        case .proccesedTappedButtonCell(let id):
            tappedCell(cartItemId: id)
        case .proccesedTappedButtonSave(let id):
            saveProductItem(cartItemId: id)
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

    private func tappedCell(cartItemId: Int) {
        for sectionIndex in sections.indices {
            let section = sections[sectionIndex]
            if case .bodySection(let id, var items) = section {
                for itemIndex in items.indices {
                    if case .bodyICell(let product) = items[itemIndex], product.cartItemId == cartItemId {
                        output?.proccesedTappedProductCell(id: product.productId)
                    }
                }
            }
        }
    }

    private func increaseCartItem(cartItemId: Int) {
        repository.increaseCart(cartId: cartItemId) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let data):
                for sectionIndex in sections.indices {
                    let section = sections[sectionIndex]
                    if case .bodySection(let id, var items) = section {
                        for itemIndex in items.indices {
                            if case .bodyICell(let product) = items[itemIndex], product.cartItemId == cartItemId {
                                var newProduct = product
                                newProduct.id = UUID()
                                newProduct.quantity = String(data.cartItemQuantity)
                                newProduct.productPrice = String(data.totalPrice)
                                items[itemIndex] = .bodyICell(newProduct)
                                sections[sectionIndex] = .bodySection(id: id, items: items)
                                state = .content(displayData: sections)
                            }
                        }
                    }
                }
            case .failure:
                break
            }
        }
    }

    private func saveProductItem(cartItemId: Int) {
        for sectionIndex in sections.indices {
            let section = sections[sectionIndex]
            if case .bodySection(let id, var items) = section {
                for itemIndex in items.indices {
                    if case .bodyICell(let product) = items[itemIndex], product.cartItemId == cartItemId {

                        repository.proccesedTappedLikeButton(productId: product.productId) { [weak self] result in
                            guard let self = self else { return }
                            switch result {
                            case .success(let data):
                                var newProduct = product
                                newProduct.id = UUID()
                                newProduct.productSavedStatus = data
                                items[itemIndex] = .bodyICell(newProduct)
                                sections[sectionIndex] = .bodySection(id: id, items: items)
                                state = .content(displayData: sections)
                            case .failure:
                                break
                            }
                        }
                    }
                }
            }
        }
    }

    private func reduceCartItem(cartItemId: Int) {
        repository.reduceCart(cartId: cartItemId) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let data):
                for sectionIndex in sections.indices {
                    let section = sections[sectionIndex]
                    if case .bodySection(let id, var items) = section {
                        for itemIndex in items.indices {
                            if case .bodyICell(let product) = items[itemIndex], product.cartItemId == cartItemId {
                                var newProduct = product
                                newProduct.id = UUID()
                                newProduct.quantity = String(data.cartItemQuantity)
                                newProduct.productPrice = String(data.totalPrice)
                                items[itemIndex] = .bodyICell(newProduct)
                                sections[sectionIndex] = .bodySection(id: id, items: items)
                                state = .content(displayData: sections)
                            }
                        }
                    }
                }
            case .failure:
                break
            }
        }
    }

    private func removeCartItem(cartItemId: Int) {
        repository.removeCart(cartId: cartItemId) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success:
                for sectionIndex in sections.indices {
                    let section = sections[sectionIndex]
                    if case .bodySection(let id, var items) = section {
                        for itemIndex in items.indices {
                            if case .bodyICell(let product) = items[itemIndex], product.cartItemId == cartItemId {
                                items.remove(at: itemIndex)
                                sections[sectionIndex] = .bodySection(id: id, items: items)
                                state = .content(displayData: sections)
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

