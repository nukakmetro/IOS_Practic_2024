//
//  CategoryViewModel.swift
//  FoodZ
//
//  Created by surexnx on 20.04.2024.
//

import Foundation
import Combine

protocol CreateProductOutput: AnyObject {
    func proccesedTapChoseItem(_ builder: CreateProductBuilder)
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

    let headerName: String
    private var builder: CreateProductBuilder

    // MARK: Initializator

    init(output: CreateProductOutput, _ builder: CreateProductBuilder) {
        self.output = output
        self.stateDidChange = ObservableObjectPublisher()
        self.state = .content
        self.builder = builder
        self.headerName = "Категория"
    }

    // MARK: Internal methods

    func trigger(_ intent: CreateProductIntent) {
        switch intent {
        case .onClose:
            break
        case .proccedButtonTapedNext(let value):
            addPiece(value)
        case .onDidLoad:
            break
        case .proccedButtonTapedBack:
            break
        }
    }

    // MARK: Private methods

    private func addPiece(_ value: String) {
        output?.proccesedTapChoseItem(builder.addProductCategory(value))
    }
}
extension CategoryViewModel: CreateProductInput {

    func proccesedCarryOutData(_ builder: CreateProductBuilder) {
        self.builder = builder
    }
}
