//
//  SelfProductViewModel.swift
//  FoodZ
//
//  Created by surexnx on 04.05.2024.
//

import Foundation
import Combine

protocol AddMaindVewModeling: UIKitViewModel where State == AddMainState, Intent == AddMainIntent {}

final class AddMainViewModel: AddMaindVewModeling {

    // MARK: Private properties

    private(set) var stateDidChange: ObservableObjectPublisher
    weak private var output: AddMainModuleOutput?
    private var repository: ProfileUserProtocol
    private let coreDataManager: CoreDataManager

    // MARK: Internal properties

    @Published var state: AddMainState {
        didSet {
            stateDidChange.send()
        }
    }

    // MARK: Initializator

    init(output: AddMainModuleOutput, repository: ProfileUserProtocol, coreDataManager: CoreDataManager) {
        self.stateDidChange = ObjectWillChangePublisher()
        self.output = output
        self.repository = repository
        self.state = .loading
        self.coreDataManager = coreDataManager
    }

    // MARK: Internal methods

    func trigger(_ intent: AddMainIntent) {
        switch intent {
        case .onDidLoad:
            break
        case .onClose:
            break
        case .onReload:
            break
        case .proccesedTappedCreateProduct:
            output?.proccesedMainTappedCreateProduct(product: coreDataManager.createNewProduct())
        }
    }
}
