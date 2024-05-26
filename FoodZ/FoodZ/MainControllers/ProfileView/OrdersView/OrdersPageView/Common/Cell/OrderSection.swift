//
//  OrdersViewCellType.swift
//  FoodZ
//
//  Created by surexnx on 28.04.2024.
//

import Foundation

enum OrderSectionType: Hashable {
    case bodySection(_ id: UUID, [OrderCellType])
    case bodyHeaderSection(_ id: UUID, OrderCellType)
    func hash(into hasher: inout Hasher) {
        switch self {
        case .bodySection(let id, _):
            hasher.combine(id)
        case .bodyHeaderSection(let id, _):
            hasher.combine(id)
        }
    }

    static func == (lhs: OrderSectionType, rhs: OrderSectionType) -> Bool {
        switch (lhs, rhs) {
        case (.bodySection(let lhsId, _), .bodySection(let rhsId, _)):
            return lhsId == rhsId
        case (.bodyHeaderSection(let lhsId, _), .bodyHeaderSection(let rhsId, _)):
            return lhsId == rhsId
        default:
            return false
        }
    }
}

enum OrderCellType: Hashable {
    case bodyCell(OrderBody)
    case bodyHeaderCell(OrderBodyHeader)
}

struct OrderBodyHeader: Hashable {
    var id: UUID
    var orderId: String
    var totalPrice: String
    var status: Int
    var whose: Bool

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

struct OrderBody: Hashable {
    var id: UUID
    var productId: Int
    var price: String
    var quantity: String
    var productName: String
    var productCategory: String
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
