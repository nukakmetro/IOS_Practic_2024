//
//  SearchSection.swift
//  FoodZ
//
//  Created by surexnx on 26.05.2024.
//

import Foundation

enum SearchSectionType: Hashable {
    case headerSection(_ id: UUID, SearchCellType)
    case bodySection(_ id: UUID, [SearchCellType])

    func hash(into hasher: inout Hasher) {
        switch self {
        case .bodySection(let id, _):
            hasher.combine(id)
        case .headerSection(let id, _):
            hasher.combine(id)
        }
    }

    static func == (lhs: SearchSectionType, rhs: SearchSectionType) -> Bool {
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

enum SearchCellType: Hashable {
    case header
    case bodyCell(ProductCell)
}
