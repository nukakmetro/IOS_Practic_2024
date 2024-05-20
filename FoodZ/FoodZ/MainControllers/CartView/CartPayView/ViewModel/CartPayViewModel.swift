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
    private let repository: CartProtocol
    private(set) var stateDidChange: ObservableObjectPublisher
    private var sections: [CartSectionType]
    private let dataMapper: CartDataMapper
    private var viewData: CartViewData

    // MARK: Internal properties

    @Published var state: CartPayState {
        didSet {
            stateDidChange.send()
        }
    }

    // MARK: Initialization

    init(output: CartPayModuleOutput, remoteRepository: CartProtocol) {
        self.stateDidChange = ObjectWillChangePublisher()
        self.state = .loading
        self.output = output
        self.repository = remoteRepository
        self.sections = []
        self.dataMapper = CartDataMapper()
        self.viewData = CartViewData(totalPrice: 0)
        NotificationCenter.default.addObserver(self, selector: #selector(handleSelectCartTab), name: .selectCartTab, object: nil)
    }

    // MARK: Internal methods

    func trigger(_ intent: CartPayIntent) {
        switch intent {

        case .onClose:
            break
        case .onDidLoad:
            break
        case .onLoad:
            break
        case .onReload:
            break
        }
    }

    private func getCart() {
        state = .loading
        repository.getCart { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let data):
                sections = dataMapper.displayData(data: data)
                viewData.totalPrice = data.totalPrice
                state = .content(displayData: sections, viewData)
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
                     //   output?.proccesedTappedProductCell(id: product.productId)
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
                                viewData.totalPrice = data.totalPrice
                                state = .content(displayData: sections, viewData)
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
                                state = .content(displayData: sections, viewData)
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
                                viewData.totalPrice = data.totalPrice
                                state = .content(displayData: sections, viewData)
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
                                state = .content(displayData: sections, viewData)
                                getTotalPrice()
                            }
                        }
                    }
                }
            case .failure:
                break
            }
        }
    }

    private func getTotalPrice() {
        repository.getTotalPrice { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let data):
                viewData.totalPrice = data.totalPrice
                state = .content(displayData: sections, viewData)
            case .failure:
                break
            }
        }
    }

    @objc private func handleSelectCartTab() {
        trigger(.onReload)
    }
}

