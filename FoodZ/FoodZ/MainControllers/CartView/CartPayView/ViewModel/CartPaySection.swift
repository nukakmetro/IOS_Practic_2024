//
//  CartPaySection.swift
//  FoodZ
//
//  Created by surexnx on 22.05.2024.
//

import Foundation

enum CartPaySectionType: Hashable {
    case bodySection(id: UUID, [CartPayCellType])
    case bodyHeaderSection(id: UUID, CartPayCellType)
    case footerSection(id: UUID, CartPayCellType)

    func hash(into hasher: inout Hasher) {
        switch self {
        case .bodySection(let id, _):
            hasher.combine(id)
        case .bodyHeaderSection(let id, _):
            hasher.combine(id)
        case .footerSection(let id, _):
            hasher.combine(id)
        }
    }

    static func == (lhs: CartPaySectionType, rhs: CartPaySectionType) -> Bool {
        switch (lhs, rhs) {
        case (.bodySection(let lhsId, _), .bodySection(let rhsId, _)):
            return lhsId == rhsId
        case (.bodyHeaderSection(id: let lhsId, _), .bodyHeaderSection(id: let rhsId, _)):
            return lhsId == rhsId
        case (.footerSection(id: let lhsId, _), .footerSection(id: let rhsId, _)):
            return lhsId == rhsId
        default:
            return false
        }
    }
}

enum CartPayCellType: Hashable {
    case bodyCell(CartPayBody)
    case bodyHeaderCell(CartPayHeader)
    case footerCell(CartPayFooter)
}

struct CartPayBody: Hashable {
    var id: UUID
    var price: String
    var name: String
    var quantity: String

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

struct CartPayHeader: Hashable {
    var address: String
}

struct CartPayFooter: Hashable {
    var totalPrice: String

}
