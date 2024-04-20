//
//  CategoryViewModel.swift
//  FoodZ
//
//  Created by surexnx on 20.04.2024.
//

import Foundation
import Combine

protocol CreateProductOutput: AnyObject {
    func proccesedTapNext(_ builder: CreateProductBuilder)
}

final class CategoryViewModel: CreateProductViewModeling {

    // MARK: Private properties

    weak private var output: CreateProductOutput?
    private(set) var stateDidChange: ObservableObjectPublisher
    @Published private(set) var state: CreateProductState {
        didSet {
            stateDidChange.send()
        }
    }
    private var builder: CreateProductBuilder
    private var createState: CreateState

    // MARK: Initializator


    init(output: CreateProductOutput, createState: CreateState) {
        self.output = output
        self.stateDidChange = ObservableObjectPublisher()
        self.state = .content
        self.createState = createState
        builder = CreateProductBuilder()
    }

    // MARK: Internal methods

    func trigger(_ intent: CreateProductIntent) {
        switch intent {
        case .onClose:
            break
        case .proccedButtonTapedNext(let value):
            break
        case .onDidLoad:
            break
        case .proccedButtonTapedBack:
            break
        }
    }

    private func addPiece(_ value: String) {
        switch createState {
        case .category:
            output?.proccesedTapNext(self.builder.addProductCategory(value))
        }
    }
}
extension CategoryViewModel: CreateProductInput {

    func proccesedCarryOutData(_ builder: CreateProductBuilder) {
        self.builder = builder
    }
}
