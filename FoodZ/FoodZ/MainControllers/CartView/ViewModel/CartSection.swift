//
//  Section.swift
//  FoodZ
//
//  Created by surexnx on 17.05.2024.
//

import Foundation

enum CartSectionType: Hashable {
    case bodySection(id: UUID, items: [CartCellType])

    func hash(into hasher: inout Hasher) {
        switch self {
        case .bodySection(let id, _):
            hasher.combine(id)
        }
    }

    static func ==(lhs: CartSectionType, rhs: CartSectionType) -> Bool {
        switch (lhs, rhs) {
        case (.bodySection(let lhsId, _), .bodySection(let rhsId, _)):
            return lhsId == rhsId
        }
    }
}

enum CartCellType: Hashable {
    case bodyICell(CartProduct)

    func hash(into hasher: inout Hasher) {
        switch self {
        case .bodyICell(let product):
            hasher.combine(product.id)
        }
    }

    static func ==(lhs: CartCellType, rhs: CartCellType) -> Bool {
        switch (lhs, rhs) {
        case (.bodyICell(let lhsProduct), .bodyICell(let rhsProduct)):
            return lhsProduct.id == rhsProduct.id  // Compare only by productId
        }
    }
}

struct CartProduct: Hashable {
    var id: UUID
    var productId: Int
    var cartItemId: Int
    var productPrice: String
    var productImageId: Int
    var productName: String
    var productCategory: String
    var productCompound: String
    var productDescription: String
    var productSavedStatus: Bool
    var quantity: String

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
