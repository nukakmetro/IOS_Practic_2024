//
//  FilingViewModel.swift
//  FoodZ
//
//  Created by surexnx on 05.05.2024.
//

import Foundation
import Combine

enum FillingCellType: Hashable {
    case oneLine(FillingData)
}

struct FillingData: Hashable {
    var name: String?
    var value: String?
    var error: Bool
}

protocol FillingViewModeling: UIKitViewModel where State == FilingState, Intent == FilingIntent {}

final class FillingViewModel: FillingViewModeling {

    // MARK: Private properties

    private(set) var stateDidChange: ObservableObjectPublisher
    weak private var output: FillingModuleOutput?
    private var repository: ProfileUserProtocol
    private let dataMapper: FillingDataMapper
    private var items: [FillingCellType]

    // MARK: Internal properties

    @Published var state: FilingState {
        didSet {
            stateDidChange.send()
        }
    }

    // MARK: Initializator

    init(output: FillingModuleOutput, repository: ProfileUserProtocol) {
        self.stateDidChange = ObjectWillChangePublisher()
        self.output = output
        self.repository = repository
        self.state = .loading
        self.dataMapper = FillingDataMapper()
        self.items = []
    }

    // MARK: Internal methods

    func trigger(_ intent: FilingIntent) {
        switch intent {
        case .onDidLoad:
            state = .loading
            output?.fillingModuleDidLoad(input: self)
            trigger(.onLoad(items))
        case .onClose:
            break
        case .onReload:
            state = .loading
            state = .content(self.items)
        case .proccesedTappedContinue(let data):
            tappedContinue(fillingData: data)
        case .onLoad(let items):
            state = .content(items)
        }
    }

    private func tappedContinue(fillingData: [FillingData]) {
        var isError = false
        for var data in fillingData {
            if data.value == nil {
                data.error = true
                isError = true
            }
        }
        if isError {
            state = .error(dataMapper.displayData(from: fillingData))
        } else {
            guard let product = dataMapper.reverse(data: fillingData) else { return }
            output?.proccesedTappedNextView(product: product)
        }
    }
}

// MARK: - FillingModuleInput

extension FillingViewModel: FillingModuleInput {
    func proccesedGiveAwayProduct(product: ProductEntity) {
        items = dataMapper.dispayData(from: product)
    }
}
