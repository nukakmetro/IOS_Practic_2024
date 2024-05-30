//
//  SavedSection.swift
//  FoodZ
//
//  Created by surexnx on 26.05.2024.
//

import Foundation

enum SavedSectionType: Hashable {
    case bodySection(_ id: UUID, [SavedCellType])
    
    func hash(into hasher: inout Hasher) {
        switch self {
        case .bodySection(let id, _):
            hasher.combine(id)
        }
    }

    static func == (lhs: SavedSectionType, rhs: SavedSectionType) -> Bool {
        switch (lhs, rhs) {
        case (.bodySection(let lhsId, _), .bodySection(let rhsId, _)):
            return lhsId == rhsId
        }
    }
}

enum SavedCellType: Hashable {
    case bodyCell(ProductCell)
}
