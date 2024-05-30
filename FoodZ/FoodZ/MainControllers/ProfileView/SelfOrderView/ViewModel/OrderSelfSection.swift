//
//  SelfOrderSection.swift
//  FoodZ
//
//  Created by surexnx on 26.05.2024.
//

import Foundation

enum OrderSelfSectionType: Hashable {
    case bodySection(_ id: UUID, [OrderSelfCellType])
    case headerSection(_ id: UUID, OrderSelfCellType)

    func hash(into hasher: inout Hasher) {
        switch self {
        case .bodySection(let id, _):
            hasher.combine(id)
        case .headerSection(let id, _):
            hasher.combine(id)
        }
    }

    static func == (lhs: OrderSelfSectionType, rhs: OrderSelfSectionType) -> Bool {
        switch (lhs, rhs) {
        case (.bodySection(let lhsId, _), .bodySection(let rhsId, _)):
            return lhsId == rhsId
        case (.headerSection(let lhsId, _), .headerSection(let rhsId, _)):
            return lhsId == rhsId
        default:
            return false
        }
    }
}

enum OrderSelfCellType: Hashable {
    case bodyCell(OrderSelfBody)
    case headerCell(OrderSelfHeader)
}

struct OrderSelfHeader: Hashable {
    var id: UUID
    var orderId: String
    var totalPrice: String
    var status: Int
    var whose: Bool

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

struct OrderSelfBody: Hashable {
    var id: UUID
    var productId: Int
    var price: String
    var quantity: String
    var productName: String
    var productCategory: String
    var imageId: Int
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

struct OrderSelfViewData {
    var status: Int
    var whose: Bool
}
