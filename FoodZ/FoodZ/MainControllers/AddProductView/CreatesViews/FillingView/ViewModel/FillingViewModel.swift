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
    private var count: Int

    // MARK: Internal properties

    @Published var state: FilingState {
        didSet {
            stateDidChange.send()
        }
    }

    // MARK: Initialization

    init(output: FillingModuleOutput, repository: ProfileUserProtocol) {
        self.stateDidChange = ObjectWillChangePublisher()
        self.output = output
        self.repository = repository
        self.state = .loading
        self.dataMapper = FillingDataMapper()
        self.items = []
        count = 0
    }

    // MARK: Internal methods

    func trigger(_ intent: FilingIntent) {
        switch intent {
        case .onDidLoad:
            output?.fillingModuleDidLoad(input: self)
        case .onClose:
            break
        case .onReload:
            state = .loading
            state = .content(items)
        case .proccesedTappedContinue(let data):
            tappedContinue(fillingData: data)
        case .onLoad:
            state = .content(items)
        case .proccesedTappedSaveButton(let data):
            tappedSave(fillingData: data)
        }
    }

    // MARK: Private methods

    private func tappedSave(fillingData: [FillingData]) {
        guard let product = dataMapper.reverse(data: fillingData) else { return }
        output?.fillingProccesedTappedSaveButton(product: product)
    }

    private func tappedContinue(fillingData: [FillingData]) {
        var isError = false
        var newFillingData = fillingData
        newFillingData.indices.forEach { index in
            let data = newFillingData[index]
            if data.value == "" {
                isError = true
                newFillingData[index] = FillingData(
                    name: newFillingData[index].name,
                    value: newFillingData[index].value,
                    error: true
                )
            } 
        }
        if isError {
            state = .error(dataMapper.displayData(from: newFillingData))
        } else {
            guard let product = dataMapper.reverse(data: fillingData) else { return }
            output?.proccesedTappedNextView(product: product)
        }
    }
}

// MARK: - FillingModuleInput

extension FillingViewModel: FillingModuleInput {
    func proccesedGiveAwayProduct(product: ProductCreator) {
        items = dataMapper.dispayData(from: product)
    }
}
