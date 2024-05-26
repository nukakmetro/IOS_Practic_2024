//
//  Tabs.swift
//  FoodZ
//
//  Created by surexnx on 31.03.2024.
//

import Foundation

enum HomeSectionType: Hashable {
    case headerSection(id: UUID, HomeCellType)
    case bodyHeaderSection(id: UUID, HomeCellType)
    case bodySection(id: UUID, [HomeCellType])

    func hash(into hasher: inout Hasher) {
        switch self {
        case .headerSection(let id, _):
            hasher.combine(id)
        case .bodyHeaderSection(let id, _):
            hasher.combine(id)
        case .bodySection(let id, _):
            hasher.combine(id)
        }
    }

    static func == (lhs: HomeSectionType, rhs: HomeSectionType) -> Bool {
        switch (lhs, rhs) {
        case (.headerSection(let lhsId, _), .headerSection(let rhsId, _)):
            return lhsId == rhsId
        case (.bodyHeaderSection(id: let lhsId, _), .bodyHeaderSection(id: let rhsId, _)):
            return lhsId == rhsId
        case (.bodySection(id: let lhsId, _), .bodySection(id: let rhsId, _)):
            return lhsId == rhsId
        default:
            return false
        }
    }

}

enum HomeCellType: Hashable {
    case headerCell
    case bodyHeaderCell(ProductHeader)
    case bodyCell(ProductCell)

}

struct ProductHeader: Hashable {
    var id: UUID
    var title: String
}

struct ProductCell: Hashable {
    var id: UUID
    var productDescription: String
    var productId: Int
    var productName: String
    var productPrice: Int
    var productWaitingTime: Int
    var productRating: Int
    var productUsername: String
    var productCategory: String
    var productCompound: String
    var productImageId: Int
    var productSavedStatus: Bool

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

struct Section: Decodable {
    let title: String
    let products: [Product]
}

struct Product: Decodable, Hashable {
    var productDescription: String
    var productId: Int
    var productPrice: Int
    var productWaitingTime: Int
    var productRating: Int
    var productImageId: Int
    var productUsername: String
    var productCategory: String
    var productCompound: String
    var productName: String
    var productSavedStatus: Bool
}

struct Image: Decodable, Hashable {
    var imageName: String
    var imageId: Int
}
