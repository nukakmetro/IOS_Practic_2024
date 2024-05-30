//
//  SelfOrderViewModel.swift
//  FoodZ
//
//  Created by surexnx on 26.05.2024.
//

import Foundation
import Combine

protocol OrderSelfViewModeling: UIKitViewModel where State == OrderSelfState, Intent == OrderSelfIntent {}

final class OrderSelfViewModel: OrderSelfViewModeling {

    // MARK: Private properties

    private(set) var stateDidChange: ObservableObjectPublisher
    weak private var output: OrderSelfModuleOutput?
    private var repository: OrderSelfProtocol
    private let dataMapper: OrderSelfDataMapper
    private var sections: [OrderSelfSectionType]
    private var contentData: OrderSelfViewData
    private var id: Int?

    // MARK: Internal properties

    @Published var state: OrderSelfState {
        didSet {
            stateDidChange.send()
        }
    }

    // MARK: Initialization

    init(output: OrderSelfModuleOutput, repository: OrderSelfProtocol) {
        self.stateDidChange = ObjectWillChangePublisher()
        self.output = output
        self.repository = repository
        self.state = .loading
        self.dataMapper = OrderSelfDataMapper()
        self.sections = []
        self.contentData = OrderSelfViewData(status: 0, whose: false)
    }

    // MARK: Internal methods

    func trigger(_ intent: OrderSelfIntent) {
        switch intent {

        case .onDidLoad:
            output?.selfProductModuleDidLoad(input: self)
        case .onLoad:
            getOrder()
        case .onClose:
            break
        case .onReload:
            getOrder()
        case .proccesedTappedButtonReady:
            changeToReady()
        case .proccesedTappedButtoncompleted:
            changeToCompleted()
        }
    }

    // MARK: Private methods

    private func getOrder() {
        guard let id = id else { return }
        repository.getOrder(orderId: id) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let data):
                sections = dataMapper.dispayData(from: data)
                contentData.status = data.status
                contentData.whose = data.whose
                state = .content(sections, viewData: contentData)
            case .failure:
                break
            }
        }
    }

    private func changeToReady() {
        guard let id = id else { return }
        repository.orderStatusReady(id: id) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success:
                contentData.status = 1
                state = .content(sections, viewData: contentData)
            case .failure:
                break
            }
        }
    }

    private func changeToCompleted() {
        guard let id = id else { return }
        repository.orderStatusCompleted(id: id) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success:
                contentData.status = 2
                state = .content(sections, viewData: contentData)
            case .failure:
                break
            }
        }
    }
}

// MARK: - OrderSelfModuleInput

extension OrderSelfViewModel: OrderSelfModuleInput {
    func proccesedSendId(id: Int) {
        self.id = id
    }
}

