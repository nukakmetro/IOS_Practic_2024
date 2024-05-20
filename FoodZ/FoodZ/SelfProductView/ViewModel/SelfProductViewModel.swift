//
//  SelfProductViewModel.swift
//  FoodZ
//
//  Created by surexnx on 13.05.2024.
//

import Foundation
import Combine

protocol SelfProductViewModeling: UIKitViewModel where State == SelfProductState, Intent == SelfProductIntent {}

final class SelfProductViewModel: SelfProductViewModeling {

    // MARK: Private properties

    private(set) var stateDidChange: ObservableObjectPublisher
    weak private var output: SelfProductModuleOutput?
    private var repository: ProductSelfProtocol & ProductToggleLikeProtocol
    private let dataMapper: SelfProductDataMapper
    private var sections: [SelfProductSectionType]
    private var contentData: SelfProductContentData
    private var id: Int?

    // MARK: Internal properties

    @Published var state: SelfProductState {
        didSet {
            stateDidChange.send()
        }
    }

    // MARK: Initialization

    init(output: SelfProductModuleOutput, repository: ProductSelfProtocol & ProductToggleLikeProtocol) {
        self.stateDidChange = ObjectWillChangePublisher()
        self.output = output
        self.repository = repository
        self.state = .loading
        self.dataMapper = SelfProductDataMapper()
        self.sections = []
        self.contentData = SelfProductContentData(cartButton: 1, likeButton: false)
    }

    // MARK: Internal methods

    func trigger(_ intent: SelfProductIntent) {
        switch intent {

        case .onDidLoad:
            output?.selfProductModuleDidLoad(input: self)
        case .onLoad:
            getProduct()
        case .onClose:
            break
        case .onReload:
            break
        case .proccesedTappedButtonLike:
            guard let id = id else { return }
            productTappedLike(productId: id)
        case .proccesedTappedButtonAddToCart:

            proccesedTappedButtonAddToCart()
        case .proccesedTappedButtonCart:
            output?.proccesedTappedButtonCart()
        }
    }

    // MARK: Private methods

    private func getProduct() {
        state = .loading
        guard let id = self.id else { return }
        repository.getProduct(productId: id) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let data):
                contentData = SelfProductContentData(cartButton: data.productBuyStatus, likeButton: data.productSavedStatus)
                sections = dataMapper.displayData(from: data)
                state = .content(sections, viewData: contentData)
            case .failure:
                break
            }
        }
    }

    private func proccesedTappedButtonAddToCart() {

        guard let id = self.id else { return }
        repository.insertCart(productId: id) { [weak self] result in
            guard let self = self else { return }

            switch result {
            case .success:
                contentData.cartButton = 2
                state = .content(sections, viewData: contentData)
            case .failure:
                break
            }
        }
    }

    private func productTappedLike(productId: Int) {
        state = .loading

        repository.proccesedTappedLikeButton(productId: productId) { [weak self] result in
            guard let self else { return }

            switch result {
            case .success(let like):
                contentData.likeButton = like
                state = .content(sections, viewData: contentData)
            case .failure:
                break
            }
        }
    }
}

// MARK: - Private methods

extension SelfProductViewModel: SelfProductModuleInput {
    func proccesedSendId(id: Int) {
        self.id = id
    }
}
